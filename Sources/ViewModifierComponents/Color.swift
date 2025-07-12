extension View {
    public func color(_ foregroundColor: Color) -> some View {
        modifier(ColorModifier(foregroundColor: foregroundColor, backgroundColor: nil))
    }

    public func backgroundColor(_ backgroundColor: Color) -> some View {
        modifier(ColorModifier(foregroundColor: nil, backgroundColor: backgroundColor))
    }
}

public struct ColorModifier: ViewModifier {
    let foregroundColor: Color?
    let backgroundColor: Color?

    public func body(content: Content) -> some View {
        ColorView(
            content: content, foregroundColor: foregroundColor, backgroundColor: backgroundColor)
    }
}

private struct ColorView<Content>: View where Content: View {
    let content: Content
    let foregroundColor: Color?
    let backgroundColor: Color?
}
extension ColorView: NodeBuilder {
    func buildNode(viewIdentifier: ViewIdentifier) -> Node {
        ColorNode(
            viewIdentifier: viewIdentifier,
            foregroundColor: foregroundColor, backgroundColor: backgroundColor)
    }

    func childViews() -> [any View] {
        [content]
    }
}

private class ColorNode: Node {
    init(
        viewIdentifier: ViewIdentifier,
        foregroundColor: Color?, backgroundColor: Color?
    ) {
        super.init(viewIdentifier: viewIdentifier)
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }
}

extension ColorNode: RenderableNode {
    func proposeViewSize(inSize: Size) -> Size {
        assert(renderableChildren.count == 1, "There should be only one renderable child")
        let renderableChild = renderableChildren[0]

        let proposedChildViewSize = renderableChild.proposeViewSize(inSize: inSize)

        return (
            width: max(proposedChildViewSize.width, 0), height: max(proposedChildViewSize.height, 0)
        )
    }

    func render(context: RenderContext, start: Point, size: Size) {
        assert(renderableChildren.count == 1, "There should be only one renderable child")
        let renderableChild = renderableChildren[0]

        for x in 0..<Int(size.width) {
            for y in 0..<Int(size.height) {
                draw(with: context, at: (start.x + x, start.y + y))
            }
        }

        renderableChild.render(context: context, start: start, size: size)
    }
}
