@resultBuilder
struct ViewBuilder {
    static func buildEither<T, F>(first component: T) -> ConditionalView<T, F>
    where T: View, F: View {
        ConditionalView<T, F>.truthy {
            component
        }
    }

    static func buildEither<T, F>(second component: F) -> ConditionalView<T, F>
    where T: View, F: View {
        ConditionalView<T, F>.falsy {
            component
        }
    }

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
        repeat each Content
    > where repeat each Content: View {
        TupleView((repeat each content))
    }
}
