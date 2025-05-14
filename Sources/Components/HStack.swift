public struct HStack<Content>: View where Content: View {
    let content: Content
    let alignment: VerticalAlignment
    let spacing: Int

    public init(
        alignment: VerticalAlignment = .center, spacing: Int = 1,
        @ViewBuilder content: () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }
}

extension HStack: NodeBuilder {
    func buildNode() -> Node? {
        return HStackNode(view: self)
    }

    func childViews() -> [any View] {
        return [content]
    }
}

class HStackNode<Content: View>: Node {
    var hStackView: HStack<Content> {
        guard let view = view as? HStack<Content> else {
            fatalError("HStackNode can only be used with HStack")
        }
        return view
    }

    init(view: HStack<Content>) {
        super.init(view: view)
    }
}

extension HStackNode: RenderableNode {
    func proposeViewSize(inSize: Size) -> Size {
        guard renderableChildren.count > 0 else {
            // No elements to render
            return (0, 0)
        }

        var height = 0
        var width = 0
        var availableWidth = inSize.width

        for (index, child) in self.renderableChildren.enumerated() {
            let spacing = index < renderableChildren.count - 1 ? hStackView.spacing : 0
            let childSize = child.proposeViewSize(
                inSize: (width: availableWidth, height: inSize.height))
            height = max(height, childSize.height)
            width += childSize.width + spacing
            availableWidth -= childSize.width + spacing
        }

        return (width: width, height: height)
    }

    func render(context: RenderContext, start: Point, size: Size) {
        var x = start.x
        var availableWidth = size.width

        for child in self.renderableChildren {
            let childIntrinsicSize = child.proposeViewSize(
                inSize: (width: availableWidth, height: size.height))
            let childStartY: Int =
                switch hStackView.alignment {
                case .top:
                    start.y
                case .center:
                    start.y + (size.height - childIntrinsicSize.height) / 2
                case .bottom:
                    start.y + (size.height - childIntrinsicSize.height)
                default:
                    start.y
                }
            let childStart: Point = (
                x: x,
                y: childStartY
            )
            child.render(context: context, start: childStart, size: childIntrinsicSize)
            x += childIntrinsicSize.width + hStackView.spacing
            availableWidth -= childIntrinsicSize.height + hStackView.spacing

            if availableWidth <= 0 {
                break  // Stop rendering if no more space is available
            }
        }
    }
}
