struct BoldEnvironmentKey: EnvironmentKey {
    static let defaultValue: Bool = false
}
struct ItalicEnvironmentKey: EnvironmentKey {
    static let defaultValue: Bool = false
}
struct UnderlineEnvironmentKey: EnvironmentKey {
    static let defaultValue: Bool = false
}
struct StrikethroughEnvironmentKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var bold: Bool {
        get { self[BoldEnvironmentKey.self] }
        set { self[BoldEnvironmentKey.self] = newValue }
    }
    var italic: Bool {
        get { self[ItalicEnvironmentKey.self] }
        set { self[ItalicEnvironmentKey.self] = newValue }
    }
    var underline: Bool {
        get { self[UnderlineEnvironmentKey.self] }
        set { self[UnderlineEnvironmentKey.self] = newValue }
    }
    var strikethrough: Bool {
        get { self[StrikethroughEnvironmentKey.self] }
        set { self[StrikethroughEnvironmentKey.self] = newValue }
    }
}

extension View {
    public func bold(_ isActive: Bool = true) -> some View {
        environment(\.bold, isActive)
    }
    public func italic(_ isActive: Bool = true) -> some View {
        environment(\.italic, isActive)
    }
    public func underline(_ isActive: Bool = true) -> some View {
        environment(\.underline, isActive)
    }
    public func strikethrough(_ isActive: Bool = true) -> some View {
        environment(\.strikethrough, isActive)
    }
}

extension Node {
    var bold: Bool { getEnvironmentValues().bold }
    var italic: Bool { getEnvironmentValues().italic }
    var underline: Bool { getEnvironmentValues().underline }
    var strikethrough: Bool { getEnvironmentValues().strikethrough }

    var charStyle: CharStyle {
        var style: CharStyle = []
        if bold { style.formUnion(.bold) }
        if italic { style.formUnion(.italic) }
        if underline { style.formUnion(.underline) }
        if strikethrough { style.formUnion(.strikethrough) }

        return style
    }
}
