import Foundation

final class AnthropicProvider: LLMProvider, @unchecked Sendable {
    let id = "anthropic"
    let displayName = "Anthropic"
    private let baseURL: String
    private let apiKey: String

    init(baseURL: String = AppConstants.defaultAnthropicBaseURL, apiKey: String) {
        self.baseURL = baseURL.hasSuffix("/") ? String(baseURL.dropLast()) : baseURL
        self.apiKey = "__SET_LOCALLY__"
    }

    func complete(
        _ messages: [ProviderMessage],
        model: String,
        systemPrompt: String?,
        stream: Bool
    ) async throws -> AsyncStream<StreamChunk> {
        let endpoint = "\(baseURL)/v1/messages"
        guard let url = URL(string: endpoint) else {
            throw LLMError.invalidURL(endpoint)
        }

        let apiMessages = messages.map { msg -> [String: Any] in
            ["role": msg.role.rawValue, "content": msg.content]
        }

        var body: [String: Any] = [
            "model": model,
            "messages": apiMessages,
            "max_tokens": 8192,
            "stream": stream
        ]
        if let sys = systemPrompt {
            body["system"] = sys
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
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
                        guard let data = payload.data(using: .utf8),
                              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                              let type = json["type"] as? String else {
                            continue
                        }

                        switch type {
                        case "content_block_delta":
                            if let delta = json["delta"] as? [String: Any],
                               let text = delta["text"] as? String {
                                continuation.yield(StreamChunk(.text(text)))
                            }
                        case "message_stop":
                            continuation.yield(StreamChunk(.done))
                        case "error":
                            if let error = json["error"] as? [String: Any],
                               let msg = error["message"] as? String {
                                continuation.yield(StreamChunk(.error(msg)))
                            }
                        default:
                            break
                        }
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
              let content = json["content"] as? [[String: Any]],
              let textBlock = content.first(where: { ($0["type"] as? String) == "text" }),
              let text = textBlock["text"] as? String else {
            throw LLMError.decodingError("Could not parse Anthropic response")
        }

        return AsyncStream { continuation in
            continuation.yield(StreamChunk(.text(text)))
            continuation.yield(StreamChunk(.done))
            continuation.finish()
        }
    }
}
