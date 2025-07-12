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
    func buildNode(viewIdentifier: ViewIdentifier) -> Node {
        PaddingNode(viewIdentifier: viewIdentifier, edges: edges, length: length)
    }

    func childViews() -> [any View] {
        [VStack { content }]
    }
}

private class PaddingNode: Node {
    let edges: EdgeSet
    let length: Int

    init(viewIdentifier: ViewIdentifier, edges: EdgeSet, length: Int) {
        self.edges = edges
        self.length = length
        super.init(viewIdentifier: viewIdentifier)
    }
}
extension PaddingNode: RenderableNode {
    func proposeViewSize(inSize: Size) -> Size {
        assert(renderableChildren.count == 1, "There should be only one renderable child")
        let renderableChild = renderableChildren[0]

        // Adjust the input size by subtracting padding
        let adjustedInSize = (
            width: inSize.width
                - (edges.contains(.leading) ? length : 0)
                - (edges.contains(.trailing) ? length : 0),
            height: inSize.height
                - (edges.contains(.top) ? length : 0)
                - (edges.contains(.bottom) ? length : 0)
        )

        // Get the proposed size from the child
        let proposedChildViewSize = renderableChild.proposeViewSize(inSize: adjustedInSize)

        // Adjust the proposed size by adding padding
        let proposedSize = (
            width: proposedChildViewSize.width
                + (edges.contains(.leading) ? length : 0)
                + (edges.contains(.trailing) ? length : 0),
            height: proposedChildViewSize.height
                + (edges.contains(.top) ? length : 0)
                + (edges.contains(.bottom) ? length : 0)
        )

        return (width: max(proposedSize.width, 0), height: max(proposedSize.height, 0))
    }

    func render(context: RenderContext, start: Point, size: Size) {
        assert(renderableChildren.count == 1, "There should be only one renderable child")
        let renderableChild = renderableChildren[0]

        let adjustedStart = Point(
            x: start.x + (edges.contains(.leading) ? length : 0),
            y: start.y + (edges.contains(.top) ? length : 0)
        )

        let adjustedSize = Size(
            width: size.width
                - (edges.contains(.leading) ? length : 0)
                - (edges.contains(.trailing) ? length : 0),
            height: size.height
                - (edges.contains(.top) ? length : 0)
                - (edges.contains(.bottom) ? length : 0)
        )

        renderableChild.render(context: context, start: adjustedStart, size: adjustedSize)
    }
}
