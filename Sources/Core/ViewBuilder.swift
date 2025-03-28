@resultBuilder
struct ViewBuilder {
    public static func buildExpression<Content>(_ content: Content) -> Content where Content: View {
        content
    }

    public static func buildBlock() -> EmptyView {
        EmptyView()
    }

    public static func buildBlock<Content>(_ content: Content) -> Content where Content: View {
        return content
    }

    public static func buildBlock<each Content>(_ content: repeat each Content) -> TupleView<
        (repeat each Content)
    >
    where repeat each Content: View {
        return TupleView<(repeat each Content)>((repeat each content))
    }
}
