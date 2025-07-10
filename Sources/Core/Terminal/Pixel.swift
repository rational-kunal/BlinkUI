struct Pixel: Sendable {
    var char: Character
    var fgColor: Color
    var bgColor: Color
    var charStyle: CharStyle
}
extension Pixel {
    static let blank = Pixel(char: " ", fgColor: .default, bgColor: .default, charStyle: .none)
}

public enum Color: Equatable, Sendable {
    case named(NamedColor)
    case rgb(r: UInt8, g: UInt8, b: UInt8)
    case `default`

    // Convenience static lets for common named colors
    public static let black: Color = .named(.black)
    public static let red: Color = .named(.red)
    public static let green: Color = .named(.green)
    public static let yellow: Color = .named(.yellow)
    public static let blue: Color = .named(.blue)
    public static let magenta: Color = .named(.magenta)
    public static let cyan: Color = .named(.cyan)
    public static let white: Color = .named(.white)

    public enum NamedColor: String, Sendable {
        case black = "30", red = "31", green = "32", yellow = "33", blue = "34", magenta = "35",
            cyan = "36", white = "37"
    }

    var ansiForeground: String {
        switch self {
        case .default:
            return "\u{001B}[39m"
        case .named(let named):
            return "\u{001B}[\(named.rawValue)m"
        case .rgb(let r, let g, let b):
            return "\u{001B}[38;2;\(r);\(g);\(b)m"
        }
    }

    var ansiBackground: String {
        switch self {
        case .default:
            return "\u{001B}[49m"
        case .named(let named):
            // Background colors are 40-47
            if let code = Int(named.rawValue) {
                return "\u{001B}[\(code + 10)m"
            }
            return "\u{001B}[49m"
        case .rgb(let r, let g, let b):
            return "\u{001B}[48;2;\(r);\(g);\(b)m"
        }
    }
}

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
