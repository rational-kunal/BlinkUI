protocol NodeBuilder {
    func buildNode(_ node: Node)
}

protocol NodeRenderer {
    func intrinsicSizeIn(_ size: Size, childNodes: [Node]) -> Size
    func render(context: RenderContext, start: Point, size: Size)
}

extension View {
    func buildNode(_ node: Node) {
        if let self = self as? NodeBuilder {
            self.buildNode(node)
        } else {
            self.body.buildNode(node)
        }
    }
}

class Node {
    var view: any View
    var children: [Node] = []

    init(view: any View) {
        self.view = view
    }

    func addChild(_ child: Node) {
        children.append(child)
    }

    func interinsizeIn(_ size: Size) -> Size {
        return Size(width: 0, height: 0)
    }

    func render(context: RenderContext, start: Point, size: Size) {

    }

    // Focus related
    var focusable: Bool = false
    var focused: Bool = false
    func activate() {

    }
}
extension Node: CustomStringConvertible {
    var description: String {
        return "Node(\(view)) \(children)"
    }
}
