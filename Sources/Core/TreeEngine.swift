import Foundation
import os

private let logger = Logger(subsystem: "com.rational.blinkui", category: "TreeEngine")

// Storing state separate from node because state should persist while node creation
class StateManager {
    // TODO: Store it in key:ViewIdentifier with [StateIdnetifer: Value]
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

    func removeStateStorage(forViewIdentifier: ViewIdentifier) {
        // Too costly
        let statesToRemove = stateStorage.compactMap { (stateIdentifier, _) in
            // Check if
            if stateIdentifier.viewIdentifier.isDescendent(ofViewIdentifier: forViewIdentifier) {
                return stateIdentifier
            }
            return nil
        }
        for stateToRemove in statesToRemove {
            stateStorage.remove(at: stateStorage.index(forKey: stateToRemove)!)
        }
    }
}

class TreeEngine {
    let app: any App
    unowned let engine: any AppEngineExtension
    lazy var rootNode = buildTree(fromRootView: app)
    var renderableRootNode: RenderableNode { rootNode as! RenderableNode }
    lazy var stateManager = StateManager(nodeStateDidUpdate: { [weak self] (viewIdentifier) in
        DispatchQueue.global(qos: .userInitiated).async {
            guard let self else {
                return
            }
            self.rootNode = self.buildTree(fromRootView: self.app)
            self.engine.setShouldRender()
        }
    })

    var mapOfNodes: [ViewIdentifier: Node]

    init(app: any App, engine: AppEngineExtension) {
        self.app = app
        self.mapOfNodes = [ViewIdentifier: Node]()
        self.engine = engine
    }

    // func renderTree(fromRootView rootView)

    func buildTree(fromRootView rootView: some App) -> Node {
        // Special parent node
        let viewIdentifier = ViewIdentifier().withPosition(0)
        let screen = Screen { rootView }
        let screenNode = screen.buildNode(viewIdentifier: viewIdentifier)

        mapOfNodes[viewIdentifier] = screenNode

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
        let node = nodeBuilder.buildNode(viewIdentifier: currentViewIdentifier)

        parentNode.addChild(node)
        // Node has changes so purge the sub tree
        if let cachedNode = mapOfNodes[currentViewIdentifier], cachedNode != node {
            purgeSubTree(fromNode: cachedNode)
        }

        mapOfNodes[currentViewIdentifier] = node

        populateInternals(fromView: view, node: node)

        for (position, childView) in nodeBuilder.childViews().enumerated() {
            let nextViewIdentifier = currentViewIdentifier.withPosition(position)
            _buildTree(
                fromView: childView, parentNode: node,
                currentViewIdentifier: nextViewIdentifier)
        }
    }

    private func __printViewTree(fromView view: any View, level: Int) {
        let indentation = String(repeating: "  ", count: level)
        print("\(indentation)- \(type(of:view))")

        let children = (view as? NodeBuilder)?.childViews() ?? [view.body]
        for child in children {
            __printViewTree(fromView: child, level: level + 1)
        }
    }

    // Populates State and Environment wrappers
    private func populateInternals(fromView view: any View, node: Node) {
        let mirror = Mirror(reflecting: view)
        mirror.children.forEach { (label, child) in
            if let state = child as? AnyState {
                state.stateReference.stateManager = self.stateManager
                state.stateReference.stateIdentifier = node.viewIdentifier.withState(label ?? "")
            } else if let environment = child as? AnyEnvironment {
                environment.environmentReference.environmentProvider = node
            }
        }
    }

    // Purge subtree from node
    // The node has changed so purge the whole tree
    // - Remove the node from mapOfNodes
    // - Remove the state related to that node
    // - Call same on children
    private func purgeSubTree(fromNode node: Node) {
        if let indexToPurge = mapOfNodes.index(forKey: node.viewIdentifier) {
            mapOfNodes.remove(at: indexToPurge)
            stateManager.removeStateStorage(forViewIdentifier: node.viewIdentifier)
        }

        node.children.forEach { child in
            purgeSubTree(fromNode: child)
        }
    }
}
