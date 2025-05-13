extension View {
    func padding(_ edges: EdgeSet = .all, _ length: Int = 2) -> some View {
        modifier(PaddingModifier(edges: edges, length: length))
    }
}

private struct PaddingModifier: ViewModifier {
    let edges: EdgeSet
    let length: Int

    func body(content: Content) -> some View {
        PaddingView(content: content, edges: edges, length: length)
    }
}

private struct PaddingView<Content>: View where Content: View {
    let content: Content
    let edges: EdgeSet
    let length: Int
}
extension PaddingView: NodeBuilder {
    func buildNode() -> Node? {
        PaddingNode(view: self)
    }

    func childViews() -> [any View] {
        [VStack { content }]
    }
}

private class PaddingNode<Content>: Node where Content: View {
    var paddingView: PaddingView<Content> {
        guard let paddingView = view as? PaddingView<Content> else {
            fatalError("PaddingNode can only be used with Padding views")
        }
        return paddingView
    }

    init(view: PaddingView<Content>) {
        super.init(view: view)
    }
}
extension PaddingNode: RenderableNode {
    func proposeViewSize(inSize: Size) -> Size {
        assert(renderableChildren.count == 1, "There should be only one renderable child")
        let renderableChild = renderableChildren[0]

        // Adjust the input size by subtracting padding
        let adjustedInSize = (
            width: inSize.width
                - (paddingView.edges.contains(.leading) ? paddingView.length : 0)
                - (paddingView.edges.contains(.trailing) ? paddingView.length : 0),
            height: inSize.height
                - (paddingView.edges.contains(.top) ? paddingView.length : 0)
                - (paddingView.edges.contains(.bottom) ? paddingView.length : 0)
        )

        // Get the proposed size from the child
        let proposedChildViewSize = renderableChild.proposeViewSize(inSize: adjustedInSize)

        // Adjust the proposed size by adding padding
        let proposedSize = (
            width: proposedChildViewSize.width
                + (paddingView.edges.contains(.leading) ? paddingView.length : 0)
                + (paddingView.edges.contains(.trailing) ? paddingView.length : 0),
            height: proposedChildViewSize.height
                + (paddingView.edges.contains(.top) ? paddingView.length : 0)
                + (paddingView.edges.contains(.bottom) ? paddingView.length : 0)
        )

        return (width: max(proposedSize.width, 0), height: max(proposedSize.height, 0))
    }

    func render(context: RenderContext, start: Point, size: Size) {
        assert(renderableChildren.count == 1, "There should be only one renderable child")
        let renderableChild = renderableChildren[0]

        let adjustedStart = Point(
            x: start.x + (paddingView.edges.contains(.leading) ? paddingView.length : 0),
            y: start.y + (paddingView.edges.contains(.top) ? paddingView.length : 0)
        )

        let adjustedSize = Size(
            width: size.width
                - (paddingView.edges.contains(.leading) ? paddingView.length : 0)
                - (paddingView.edges.contains(.trailing) ? paddingView.length : 0),
            height: size.height
                - (paddingView.edges.contains(.top) ? paddingView.length : 0)
                - (paddingView.edges.contains(.bottom) ? paddingView.length : 0)
        )

        renderableChild.render(context: context, start: adjustedStart, size: adjustedSize)
    }
}
