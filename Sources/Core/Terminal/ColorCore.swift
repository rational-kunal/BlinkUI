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
        case black = "30"
        case red = "31"
        case green = "32"
        case yellow = "33"
        case blue = "34"
        case magenta = "35"
        case cyan = "36"
        case white = "37"
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
