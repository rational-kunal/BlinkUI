public struct VStack<Content>: View where Content: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
}
extension VStack: NodeBuilder {
    func buildNode(_ node: Node) {
        let selfNode = VStackNode(view: self)
        node.addChild(selfNode)
        if let content = content as? NodeBuilder {
            content.buildNode(selfNode)
        } else {
            (content as any View).body.buildNode(selfNode)
        }
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

    override func interinsizeIn(_ size: Size) -> Size {
        var height = 0
        var width = 0
        for child in children {
            let childSize = child.interinsizeIn(size)
            height += childSize.height
            width = max(width, childSize.width)
        }
        return (width: size.width, height: height)
    }

    override func render(context: RenderContext, start: Point, size: Size) {
        var y = start.y
        for child in children {
            child.render(context: context, start: Point(x: start.x, y: y), size: size)
            y += child.interinsizeIn(size).height
        }
    }
}
