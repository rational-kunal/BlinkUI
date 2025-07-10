struct TintEnvironmentKey: EnvironmentKey {
    static let defaultValue: Color = .blue
}
extension EnvironmentValues {
    var tintColor: Color {
        get { self[TintEnvironmentKey.self] }
        set { self[TintEnvironmentKey.self] = newValue }
    }
}

extension View {
    public func tint(_ tintColor: Color?) -> some View {
        environment(\.tintColor, tintColor ?? .blue)
    }
}

extension Node {
    var tintColor: Color { getEnvironmentValues().tintColor }
}
