public struct ZStack<Content>: View where Content: View {
    let content: Content
    let alignment: Alignment

    public init(
        alignment: Alignment = .center,
        @ViewBuilder content: () -> Content
    ) {
        self.alignment = alignment
        self.content = content()
    }
}

extension ZStack: NodeBuilder {
    func buildNode() -> Node? {
        return ZStackNode(view: self)
    }

    func childViews() -> [any View] {
        return [content]
    }
}

class ZStackNode<Content: View>: Node {
    var zStackView: ZStack<Content> {
        guard let view = view as? ZStack<Content> else {
            fatalError("ZStackNode can only be used with ZStack")
        }
        return view
    }

    init(view: ZStack<Content>) {
        super.init(view: view)
    }
}

extension ZStackNode: RenderableNode {
    func proposeViewSize(inSize: Size) -> Size {
        guard renderableChildren.count > 0 else {
            // No elements to render
            return (0, 0)
        }

        var height = 0
        var width = 0
        for child in self.renderableChildren {
            let childSize = child.proposeViewSize(inSize: inSize)
            height = max(height, childSize.height)
            width = max(width, childSize.width)
        }
        return (width: width, height: height)
    }

    func render(context: RenderContext, start: Point, size: Size) {
        for child in self.renderableChildren {
            let childIntrinsicSize = child.proposeViewSize(inSize: size)
            let offset = AlignmentUtility.calculateAlignmentOffset(
                parentSize: size, childSize: childIntrinsicSize, alignment: zStackView.alignment)
            let childStart: Point = (
                x: start.x + offset.x,
                y: start.y + offset.y
            )
            child.render(context: context, start: childStart, size: childIntrinsicSize)
        }
    }
}
