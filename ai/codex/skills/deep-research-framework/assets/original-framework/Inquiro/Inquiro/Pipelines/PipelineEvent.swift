import Foundation

enum PipelineEvent: Sendable {
    // Chat
    case streamingToken(String)
    case streamingDone

    // Research (Phase 2)
    case phaseChanged(String)
    case subQuestionGenerated(String)
    case sourceFound(url: String, title: String)
    case findingSummary(subQuestion: String, finding: String)
    case synthesisStarted
    case reviewResult(gaps: [String])

    // General
    case error(String)
    case progress(step: Int, total: Int, label: String)
}
