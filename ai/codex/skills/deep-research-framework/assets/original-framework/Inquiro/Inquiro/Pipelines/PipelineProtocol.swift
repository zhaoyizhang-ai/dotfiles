import Foundation

protocol PipelineProtocol: Sendable {
    associatedtype Input: Sendable
    func execute(_ input: Input) async throws -> AsyncStream<PipelineEvent>
}
