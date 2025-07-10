protocol NodeBuilder {
    // Build node for the view
    func buildNode(viewIdentifier: ViewIdentifier) -> Node

    // Return array of child view of this node / view
    func childViews() -> [any View]
}

extension NodeBuilder where Self: View {
    func buildNode(viewIdentifier: ViewIdentifier) -> Node {
        return Node(view: self, viewIdentifier: viewIdentifier)
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

    var environmentValues: EnvironmentValues?

    init(view: any View, viewIdentifier: ViewIdentifier) {
        self.view = view
        self.viewIdentifier = viewIdentifier
    }

    func addChild(_ child: Node) {
        child.parent = self
        children.append(child)
    }

    // Focus related
    var focusable: Bool = false
    var focused: Bool = false
    func activate() {

    }

    func getEnvironmentValues() -> EnvironmentValues {
        if let environmentValues = environmentValues ?? parent?.getEnvironmentValues() {
            return environmentValues
        }

        assertionFailure("Failed to get environment values")
        return EnvironmentValues()
    }
}

extension Node {
    func draw(on terminal: Terminal, x: Int, y: Int, symbol: Character) {
        terminal.draw(x: x, y: y, symbol: symbol, charStyle: charStyle)
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
