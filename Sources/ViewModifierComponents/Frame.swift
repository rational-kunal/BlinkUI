extension View {
    func frame(width: Int? = nil, height: Int? = nil, alignment: Alignment = .center) -> some View {
        modifier(FrameModifier(width: width, height: height, alignment: alignment))
    }
}

private struct FrameModifier: ViewModifier {
    let width: Int?
    let height: Int?
    let alignment: Alignment

    func body(content: Content) -> some View {
        FrameView(content: content, width: width, height: height, alignment: alignment)
    }
}

private struct FrameView<Content>: View where Content: View {
    let content: Content
    let width: Int?
    let height: Int?
    let alignment: Alignment
}

extension FrameView: NodeBuilder {
    func buildNode(viewIdentifier: ViewIdentifier) -> Node {
        FrameNode(view: self, viewIdentifier: viewIdentifier)
    }

    func childViews() -> [any View] {
        [VStack { content }]
    }
}

private class FrameNode<Content>: Node where Content: View {
    var frameView: FrameView<Content> {
        guard let frameView = view as? FrameView<Content> else {
            fatalError("FrameNode can only be used with Frame views")
        }
        return frameView
    }

    init(view: FrameView<Content>, viewIdentifier: ViewIdentifier) {
        super.init(view: view, viewIdentifier: viewIdentifier)
    }
}

extension FrameNode: RenderableNode {
    func proposeViewSize(inSize: Size) -> Size {
        assert(renderableChildren.count == 1, "There should be only one renderable child")
        let renderableChild = renderableChildren[0]

        // Get the proposed size from the child
        let proposedChildViewSize = renderableChild.proposeViewSize(inSize: inSize)

        // Adjust the proposed size based on the frame's width and height
        let proposedSize = (
            width: frameView.width == .infinity
                ? inSize.width : (frameView.width ?? proposedChildViewSize.width),
            height: frameView.height == .infinity
                ? inSize.height : (frameView.height ?? proposedChildViewSize.height)
        )

        return (width: max(proposedSize.width, 0), height: max(proposedSize.height, 0))
    }

    func render(context: RenderContext, start: Point, size: Size) {
        assert(renderableChildren.count == 1, "There should be only one renderable child")
        let renderableChild = renderableChildren[0]

        // Calculate the alignment offset
        let childSize = renderableChild.proposeViewSize(inSize: size)
        let offset = AlignmentUtility.calculateAlignmentOffset(
            parentSize: size, childSize: childSize, alignment: frameView.alignment)

        // Render the child with the given size and alignment offset
        renderableChild.render(
            context: context, start: Point(x: start.x + offset.x, y: start.y + offset.y),
            size: childSize)
    }
}

struct AlignmentUtility {
    static func calculateAlignmentOffset(parentSize: Size, childSize: Size, alignment: Alignment)
        -> Point
    {
        let xOffset: Int
        let yOffset: Int

        switch alignment {
        case .topLeading:
            xOffset = 0
            yOffset = 0
        case .top:
            xOffset = (parentSize.width - childSize.width) / 2
            yOffset = 0
        case .topTrailing:
            xOffset = parentSize.width - childSize.width
            yOffset = 0
        case .leading:
            xOffset = 0
            yOffset = (parentSize.height - childSize.height) / 2
        case .center:
            xOffset = (parentSize.width - childSize.width) / 2
            yOffset = (parentSize.height - childSize.height) / 2
        case .trailing:
            xOffset = parentSize.width - childSize.width
            yOffset = (parentSize.height - childSize.height) / 2
        case .bottomLeading:
            xOffset = 0
            yOffset = parentSize.height - childSize.height
        case .bottom:
            xOffset = (parentSize.width - childSize.width) / 2
            yOffset = parentSize.height - childSize.height
        case .bottomTrailing:
            xOffset = parentSize.width - childSize.width
            yOffset = parentSize.height - childSize.height
        }

        return Point(x: xOffset, y: yOffset)
    }
}
