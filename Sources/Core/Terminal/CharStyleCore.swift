struct CharStyle: OptionSet, Sendable {
    let rawValue: Int

    static let bold = CharStyle(rawValue: 1 << 0)
    static let italic = CharStyle(rawValue: 1 << 1)
    static let underline = CharStyle(rawValue: 1 << 2)
    static let strikethrough = CharStyle(rawValue: 1 << 3)
    static let none: CharStyle = []

    var ansiCode: String {
        var codes: [String] = []
        if contains(.bold) { codes.append("1") }
        if contains(.italic) { codes.append("3") }
        if contains(.underline) { codes.append("4") }
        if contains(.strikethrough) { codes.append("9") }
        if codes.isEmpty { return "\u{001B}[0m" }
        return "\u{001B}[\(codes.joined(separator: ";"))m"
    }
}
