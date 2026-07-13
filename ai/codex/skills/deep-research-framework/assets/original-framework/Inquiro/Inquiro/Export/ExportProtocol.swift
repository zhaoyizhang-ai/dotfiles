import Foundation

protocol ExportProtocol {
    func export(session: Session) throws -> Data
    var fileExtension: String { get }
    var mimeType: String { get }
}
