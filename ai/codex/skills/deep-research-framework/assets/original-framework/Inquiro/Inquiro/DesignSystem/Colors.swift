import SwiftUI

enum InquiroColors {
    // Base palette
    static let background = Color(light: "#FAFBFD", dark: "#0F1117")
    static let surface = Color(light: "#FFFFFF", dark: "#171B24")
    static let surfaceAlt = Color(light: "#F3F4F6", dark: "#1E2330")
    static let border = Color(light: "#E5E7EB", dark: "#2A3040")

    // Text
    static let textPrimary = Color(light: "#1A1D27", dark: "#E8ECF4")
    static let textSecondary = Color(light: "#6B7280", dark: "#8892A8")
    static let textTertiary = Color(light: "#9CA3AF", dark: "#505A70")

    // Mode accents
    static let chat = Color(hex: "#8B5CF6")
    static let chatLight = Color(hex: "#A78BFA")
    static let research = Color(hex: "#3B82F6")
    static let researchLight = Color(hex: "#60A5FA")
    static let brainstorm = Color(hex: "#F59E0B")
    static let brainstormLight = Color(hex: "#FBBF24")

    // Functional
    static let success = Color(hex: "#10B981")
    static let warning = Color(hex: "#EF4444")
    static let citation = Color(hex: "#06B6D4")
}

// MARK: - Color Initializers

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        self.init(
            red: Double((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: Double((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgbValue & 0x0000FF) / 255.0
        )
    }

    init(light: String, dark: String) {
        self.init(nsColor: NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
                ? NSColor(Color(hex: dark))
                : NSColor(Color(hex: light))
        })
    }
}
