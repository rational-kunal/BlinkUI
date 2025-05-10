public struct AnyView: View {
    let content: any View

    init(@ViewBuilder content: () -> any View) {
        self.content = content()
    }
}
extension AnyView: NodeBuilder {
    func childViews() -> [any View] {
        return [content]
    }
}
