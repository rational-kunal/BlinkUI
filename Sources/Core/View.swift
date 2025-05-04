public protocol View {
    associatedtype Body: View = Never
    @ViewBuilder var body: Self.Body { get }
}

extension View where Body == Never {
    public var body: Body { fatalError() }
}

extension Never: View {}

public protocol ViewModifier {
    associatedtype Body: View
    func body(content: ModifiedContent<Self>) -> Body
}

public struct ModifiedContent<Modifier: ViewModifier>: View {
    let content: any View
    let modifier: Modifier

    public var body: some View {
        modifier.body(content: self)
    }
}

extension View {
    func modifier<M: ViewModifier>(_ modifier: M) -> some View {
        ModifiedContent(content: self, modifier: modifier)
    }
}
