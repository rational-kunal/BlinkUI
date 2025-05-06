protocol NodeBuilder {
    // Build node for the self
    // If passed nil, then child will have have this nodes parent
    func buildNode() -> Node?

    // Return array of child view
    // The algorithm will then build there nodes and add it to child list of this no
    func childViews() -> [any View]
}
extension NodeBuilder {
    func buildNode() -> Node? { nil }
    func childViews() -> [any View] { [] }
}

protocol NodeRenderer {
    func intrinsicSizeIn(_ size: Size, childNodes: [Node]) -> Size
    func render(context: RenderContext, start: Point, size: Size)
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
        var result = "Node (\(view))\n"
        for child in children {
            let childDescription = child.description
                .split(separator: "\n")
                .map { "  \($0)" }
                .joined(separator: "\n")
            result += "\(childDescription)\n"
        }
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
