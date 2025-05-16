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
        return VStackNode(view: self, viewIdentifier: viewIdentifier)
    }

    func childViews() -> [any View] {
        return [content]
    }
}

class VStackNode<Content: View>: Node {
    var vStackView: VStack<Content> {
        guard let view = view as? VStack<Content> else {
            fatalError("VStackNode can only be used with VStack")
        }
        return view
    }

    init(view: VStack<Content>, viewIdentifier: ViewIdentifier) {
        super.init(view: view, viewIdentifier: viewIdentifier)
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
            let spacing = index < renderableChildren.count - 1 ? vStackView.spacing : 0
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
                switch vStackView.alignment {
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
            y += childIntrinsicSize.height + vStackView.spacing
            availableHeight -= childIntrinsicSize.height + vStackView.spacing

            if availableHeight <= 0 {
                break  // Stop rendering if no more space is available
            }
        }
    }
}
