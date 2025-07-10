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
        ColorNode(view: self, viewIdentifier: viewIdentifier)
    }

    func childViews() -> [any View] {
        [content]
    }
}

private class ColorNode<Content>: Node where Content: View {
    var colorView: ColorView<Content> {
        guard let colorView = view as? ColorView<Content> else {
            fatalError("ColorNode can only be used with Color views")
        }
        return colorView
    }

    init(view: ColorView<Content>, viewIdentifier: ViewIdentifier) {
        super.init(view: view, viewIdentifier: viewIdentifier)
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
                context.terminal.draw(
                    x: start.x + x, y: start.y + y,
                    fgColor: colorView.foregroundColor,
                    bgColor: colorView.backgroundColor)
            }
        }

        renderableChild.render(context: context, start: start, size: size)
    }
}
