struct Screen<Content>: View where Content: App {
    let content: VStack<Content>

    init(@ViewBuilder content: () -> Content) {
        self.content = VStack { content() }
    }
}

extension Screen: NodeBuilder {
    func buildNode() -> Node? {
        ScreenNode(view: self)
    }

    func childViews() -> [any View] {
        return [content]
    }
}

class ScreenNode: Node {
    override func interinsizeIn(_ size: Size) -> Size {
        assert(self.children.count == 1)
        return self.children.first?.interinsizeIn(size) ?? super.interinsizeIn(size)
    }
    override func render(context: RenderContext, start: Point, size: Size) {
        assert(self.children.count == 1)
        self.children.first?.render(context: context, start: start, size: size)
    }
}
