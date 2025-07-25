protocol NodeBuilder {
    // Build node for the view
    func buildNode(viewIdentifier: ViewIdentifier) -> Node

    // Return array of child view of this node / view
    func childViews() -> [any View]
}

extension NodeBuilder where Self: View {
    func buildNode(viewIdentifier: ViewIdentifier) -> Node {
        return Node(viewIdentifier: viewIdentifier)
    }
    func childViews() -> [any View] { [] }
}

protocol RenderableNode {
    func proposeViewSize(inSize: Size) -> Size
    func render(context: RenderContext, start: Point, size: Size)
}

protocol EnvironmentProvidable: AnyObject {
    // Gets the environment values for the given node
    func getEnvironmentValues() -> EnvironmentValues
}

class Node: EnvironmentProvidable {
    weak var parent: Node?
    let viewIdentifier: ViewIdentifier
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

    init(viewIdentifier: ViewIdentifier) {
        self.viewIdentifier = viewIdentifier
    }

    func addChild(_ child: Node) {
        child.parent = self
        children.append(child)
    }

    // Focus
    var focusable: Bool = false
    var focused: Bool = false
    func activate() {

    }

    // Colors
    var foregroundColor: Color?
    var backgroundColor: Color?

    // Environment
    var environmentValues: EnvironmentValues?
    func getEnvironmentValues() -> EnvironmentValues {
        if let environmentValues = environmentValues ?? parent?.getEnvironmentValues() {
            return environmentValues
        }

        assertionFailure("Failed to get environment values")
        return EnvironmentValues()
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
        var result = "Node (ViewIdentifier: \(viewIdentifier))\n"
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
