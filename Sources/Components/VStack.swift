public struct VStack<Content>: View where Content: View {
    let content: Content
    let alignment: HorizontalAlignment
    let spacing: Int

    public init(
        alignment: HorizontalAlignment = .center, spacing: Int = 0,
        @ViewBuilder content: () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }
}

extension VStack: NodeBuilder {
    func buildNode(viewIdentifier: ViewIdentifier) -> Node {
        return VStackNode(viewIdentifier: viewIdentifier, alignment: alignment, spacing: spacing)
    }

    func childViews() -> [any View] {
        return [content]
    }
}

class VStackNode: Node {
    let alignment: HorizontalAlignment
    let spacing: Int

    init(viewIdentifier: ViewIdentifier, alignment: HorizontalAlignment, spacing: Int) {
        self.alignment = alignment
        self.spacing = spacing
        super.init(viewIdentifier: viewIdentifier)
    }
}

extension VStackNode: RenderableNode {
    func proposeViewSize(inSize: Size) -> Size {
        guard renderableChildren.count > 0 else {
            // No elements to render
            return (0, 0)
        }

        var height = 0
        var width = 0
        var availableHeight = inSize.height

        for (index, child) in self.renderableChildren.enumerated() {
            let spacing = index < renderableChildren.count - 1 ? spacing : 0
            let childSize = child.proposeViewSize(
                inSize: (width: inSize.width, height: availableHeight))
            height += childSize.height + spacing
            width = max(width, childSize.width)
            availableHeight -= childSize.height + spacing
        }
        return (width: width, height: height)
    }

    func render(context: RenderContext, start: Point, size: Size) {
        var y = start.y
        var availableHeight = size.height

        for child in self.renderableChildren {
            let childIntrinsicSize = child.proposeViewSize(
                inSize: (width: size.width, height: availableHeight))
            let childStartX: Int =
                switch alignment {
                case .leading:
                    start.x
                case .center:
                    start.x + (size.width - childIntrinsicSize.width) / 2
                case .trailing:
                    start.x + (size.width - childIntrinsicSize.width)
                default:
                    start.x
                }
            let childStart: Point = (
                x: childStartX,
                y: y
            )
            child.render(context: context, start: childStart, size: childIntrinsicSize)
            y += childIntrinsicSize.height + spacing
            availableHeight -= childIntrinsicSize.height + spacing

            if availableHeight <= 0 {
                break  // Stop rendering if no more space is available
            }
        }
    }
}
