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
extension NodeBuilder where Self: View {
    func buildNode() -> Node? {
        return Node(view: self)
    }
}

protocol RenderableNode {
    func proposeViewSize(inSize: Size) -> Size
    func render(context: RenderContext, start: Point, size: Size)
}

class Node {
    var viewIdentifier: ViewIdentifier = ViewIdentifier()
    var view: any View
    var children: [Node] = []
    var renderableChildren: [RenderableNode] {
        children.reduce(into: []) { partialResult, child in
            if let renderableChild = child as? RenderableNode {
                partialResult.append(contentsOf: [renderableChild])
            } else {
                partialResult.append(contentsOf: child.renderableChildren)
            }
        }
    }

    init(view: any View) {
        self.view = view
    }

    func addChild(_ child: Node) {
        children.append(child)
    }

    // Focus related
    var focusable: Bool = false
    var focused: Bool = false
    func activate() {

    }
}

// TODO: Add Equatable to all Nodes
extension Node: Equatable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return type(of: lhs) == type(of: rhs) && lhs.viewIdentifier == rhs.viewIdentifier
    }
}
extension Node: CustomStringConvertible {
    var description: String {
        var result = "Node (View: \(view), ViewIdentifier: \(viewIdentifier))\n"
        // for child in children {
        //     let childDescription = child.description
        //         .split(separator: "\n")
        //         .map { "  \($0)" }
        //         .joined(separator: "\n")
        //     result += "\(childDescription)\n"
        // }
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
