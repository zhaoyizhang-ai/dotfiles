import Foundation

final class OpenAICompatibleProvider: LLMProvider, @unchecked Sendable {
    let id: String
    let displayName: String
    private let baseURL: String
    private let apiKey: String

    init(id: String = "openai", displayName: String = "OpenAI", baseURL: String, apiKey: String) {
        self.id = id
        self.displayName = displayName
        self.baseURL = baseURL.hasSuffix("/") ? String(baseURL.dropLast()) : baseURL
        self.apiKey = "__SET_LOCALLY__"
    }

    func complete(
        _ messages: [ProviderMessage],
        model: String,
        systemPrompt: String?,
        stream: Bool
    ) async throws -> AsyncStream<StreamChunk> {
        let endpoint = "\(baseURL)/chat/completions"
        guard let url = URL(string: endpoint) else {
            throw LLMError.invalidURL(endpoint)
        }

        var apiMessages: [[String: Any]] = []
        if let sys = systemPrompt {
            apiMessages.append(["role": "system", "content": sys])
        }
        for msg in messages {
            apiMessages.append(["role": msg.role.rawValue, "content": msg.content])
        }

        let body: [String: Any] = [
            "model": model,
            "messages": apiMessages,
            "stream": stream
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 120
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        if stream {
            return try await streamResponse(request: request)
        } else {
            return try await nonStreamResponse(request: request)
        }
    }

    private func streamResponse(request: URLRequest) async throws -> AsyncStream<StreamChunk> {
        let (bytes, response) = try await URLSession.shared.bytes(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw LLMError.noResponse
        }
        if httpResponse.statusCode != 200 {
            var errorText = ""
            for try await line in bytes.lines { errorText += line }
            throw LLMError.apiError("HTTP \(httpResponse.statusCode): \(errorText)")
        }

        return AsyncStream { continuation in
            Task {
                do {
                    for try await line in bytes.lines {
                        guard line.hasPrefix("data: ") else { continue }
                        let payload = String(line.dropFirst(6))
                        if payload == "[DONE]" {
                            continuation.yield(StreamChunk(.done))
                            break
                        }
                        guard let data = payload.data(using: .utf8),
                              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                              let choices = json["choices"] as? [[String: Any]],
                              let delta = choices.first?["delta"] as? [String: Any],
                              let content = delta["content"] as? String else {
                            continue
                        }
                        continuation.yield(StreamChunk(.text(content)))
                    }
                } catch {
                    continuation.yield(StreamChunk(.error(error.localizedDescription)))
                }
                continuation.finish()
            }
        }
    }

    private func nonStreamResponse(request: URLRequest) async throws -> AsyncStream<StreamChunk> {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw LLMError.noResponse
        }

        if httpResponse.statusCode != 200 {
            let errorText = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw LLMError.apiError("HTTP \(httpResponse.statusCode): \(errorText)")
        }

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = json["choices"] as? [[String: Any]],
              let message = choices.first?["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw LLMError.decodingError("Could not parse response")
        }

        return AsyncStream { continuation in
            continuation.yield(StreamChunk(.text(content)))
            continuation.yield(StreamChunk(.done))
            continuation.finish()
        }
    }
}
