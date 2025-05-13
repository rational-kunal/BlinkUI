public protocol View {
    associatedtype Body: View = Never
    @ViewBuilder var body: Self.Body { get }
}
extension View where Body == Never {
    public var body: Body { fatalError() }
}

extension Never: View {}

public protocol ViewModifier {
    typealias Content = AnyView
    associatedtype Body: View

    @ViewBuilder func body(content: Content) -> Body
}

public struct ModifiedContent<Content, Modifier>: View
where Modifier: ViewModifier, Content: View {
    let content: Content
    let modifier: Modifier

    public var body: some View {
        modifier.body(content: AnyView { content })
    }
}

extension View {
    func modifier<M: ViewModifier>(_ modifier: M) -> ModifiedContent<Self, M> {
        ModifiedContent(content: self, modifier: modifier)
    }
}
