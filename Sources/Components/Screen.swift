struct Screen<Content>: View where Content: App {
    let content: VStack<Content>

    init(@ViewBuilder content: () -> Content) {
        self.content = VStack { content() }
    }
}

extension Screen: NodeBuilder {
    func buildNode(viewIdentifier: ViewIdentifier) -> Node {
        let node = ScreenNode(view: self, viewIdentifier: viewIdentifier)
        node.environmentValues = EnvironmentValues()
        return node
    }

    func childViews() -> [any View] {
        return [content]
    }
}

class ScreenNode: Node {}
extension ScreenNode: RenderableNode {
    func proposeViewSize(inSize: Size) -> Size {
        assert(self.renderableChildren.count == 1)
        return self.renderableChildren.first?.proposeViewSize(inSize: inSize) ?? (0, 0)
    }

    func render(context: RenderContext, start: Point, size: Size) {
        assert(self.renderableChildren.count == 1)
        self.renderableChildren.first?.render(context: context, start: start, size: size)
    }
}
