import Foundation

// A simple view identifier which has locations to identifify the view uniquely
// Idea is that the ViewIdentifier will be identical accross render time
struct ViewIdentifier {
    var positions: [Int] = []

    func withPosition(_ position: Int) -> ViewIdentifier {
        return ViewIdentifier(positions: positions + [position])
    }

    func withState(_ stateName: String) -> StateIdentifier {
        return StateIdentifier(viewIdentifier: self, stateIdentifier: stateName)
    }
}
extension ViewIdentifier: Hashable {}
extension ViewIdentifier: CustomStringConvertible {
    var description: String {
        return positions.map(String.init).joined(separator: ".")
    }
}
struct StateIdentifier {
    var viewIdentifier: ViewIdentifier
    var stateIdentifier: String
}
extension StateIdentifier: Hashable {}
extension StateIdentifier: CustomStringConvertible {
    var description: String {
        return "\(viewIdentifier)->\(stateIdentifier)"
    }
}

class StateManager {
    var stateStorage = [StateIdentifier: Any]()
    let nodeStateDidUpdate: (ViewIdentifier) -> Void
    init(nodeStateDidUpdate: @escaping (ViewIdentifier) -> Void) {
        self.nodeStateDidUpdate = nodeStateDidUpdate  // check if we can do something better
    }

    subscript(key: StateIdentifier) -> Any? {
        get {
            return stateStorage[key]
        }
        set {
            stateStorage[key] = newValue
            // Maybe schedule this -- and do it in process
            nodeStateDidUpdate(key.viewIdentifier)
        }
    }
}

class TreeEngine {
    let app: any App
    lazy var rootNode = buildTree(fromRootView: app)
    lazy var stateManager = StateManager(nodeStateDidUpdate: { [weak self] (viewIdentifier) in
        DispatchQueue.global(qos: .userInitiated).async {
            guard let self else {
                return
            }
            self.rootNode = self.buildTree(fromRootView: self.app)
        }
    })

    var mapOfNodes: [ViewIdentifier: Node]

    init(app: any App) {
        self.app = app
        self.mapOfNodes = [ViewIdentifier: Node]()
    }

    // func renderTree(fromRootView rootView)

    func buildTree(fromRootView rootView: some App) -> Node {
        // Special parent node
        let screen = Screen { rootView }
        guard let screenNode = screen.buildNode() else {
            fatalError("Unable to crease a screenNode")
        }

        let viewIdentifier = ViewIdentifier().withPosition(0)
        mapOfNodes[viewIdentifier] = screenNode
        screenNode.viewIdentifier = viewIdentifier

        for (position, childView) in screen.childViews().enumerated() {
            let nextViewIdentifier = viewIdentifier.withPosition(position)
            _buildTree(
                fromView: childView, parentNode: screenNode,
                currentViewIdentifier: nextViewIdentifier)
        }

        return screenNode
    }

    // currentViewIdentifier: Identifier that this node will have
    private func _buildTree(
        fromView view: any View, parentNode: Node, currentViewIdentifier: ViewIdentifier
    ) {

        let nodeBuilder =
            (view as? NodeBuilder) ?? ClientDefinedViewNodeBuilder(clientDefinedView: view)

        var nextParentNode = parentNode
        if let node = nodeBuilder.buildNode() {
            parentNode.addChild(node)
            mapOfNodes[currentViewIdentifier] = node
            node.viewIdentifier = currentViewIdentifier

            nextParentNode = node
        }
        populateState(fromView: view, viewIdentifier: currentViewIdentifier)

        for (position, childView) in nodeBuilder.childViews().enumerated() {
            let nextViewIdentifier = currentViewIdentifier.withPosition(position)
            _buildTree(
                fromView: childView, parentNode: nextParentNode,
                currentViewIdentifier: nextViewIdentifier)
        }
    }

    // Extract State from a given View
    private func populateState(fromView view: any View, viewIdentifier: ViewIdentifier) {
        let mirror = Mirror(reflecting: view)
        mirror.children.forEach { (label, child) in
            guard let state = child as? AnyState else {
                return
            }

            state.stateReference.stateManager = self.stateManager
            state.stateReference.stateIdentifier = viewIdentifier.withState(label ?? "")
        }
    }
}

struct ClientDefinedViewNodeBuilder: NodeBuilder {
    let clientDefinedView: any View
    func buildNode() -> Node? {
        nil
    }
    func childViews() -> [any View] {
        return [clientDefinedView.body]
    }
}
// TODO: ClientDefinedViewNode
