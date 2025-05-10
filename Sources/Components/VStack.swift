public struct VStack<Content>: View where Content: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
}

extension VStack: NodeBuilder {
    func buildNode() -> Node? {
        return VStackNode(view: self)
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

    init(view: VStack<Content>) {
        super.init(view: view)
    }
}
extension VStackNode: RenderableNode {
    func proposeViewSize(inSize: Size) -> Size {
        var height = 0
        var width = 0
        // Here height can exceed
        for child in self.renderableChildren {
            let childSize = child.proposeViewSize(inSize: inSize)
            height += childSize.height
            width = max(width, childSize.width)
        }
        return (width: width, height: height)
    }

    func render(context: RenderContext, start: Point, size: Size) {
        var y = start.y
        for child in self.renderableChildren {
            let childIntrinsicSize = child.proposeViewSize(inSize: size)
            let childStart: Point = (
                x: start.x + (size.width - childIntrinsicSize.width) / 2,
                y: y/** + (size.height - childIntrinsicSize.height) / 2 **/
            )
            child.render(context: context, start: childStart, size: childIntrinsicSize)
            y += childIntrinsicSize.height
        }
    }
}
