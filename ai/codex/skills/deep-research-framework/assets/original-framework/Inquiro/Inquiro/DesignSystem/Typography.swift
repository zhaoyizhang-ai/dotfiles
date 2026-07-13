import SwiftUI

enum InquiroTypography {
    static let reportHeading = Font.system(size: 20, weight: .semibold, design: .default)
    static let sectionHeading = Font.system(size: 16, weight: .medium, design: .default)
    static let body = Font.system(size: 14, weight: .regular, design: .default)
    static let code = Font.system(size: 13, weight: .regular, design: .monospaced)
    static let citation = Font.system(size: 12, weight: .medium, design: .default)
    static let sidebar = Font.system(size: 13, weight: .medium, design: .default)
    static let timestamp = Font.system(size: 11, weight: .regular, design: .default)
    static let phaseTracker = Font.system(size: 11, weight: .semibold, design: .default)

    static let reportLineSpacing: CGFloat = 8 // Approximates 1.6x with 14pt body
    static let maxContentWidth: CGFloat = 680
}
