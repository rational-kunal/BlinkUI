import os

class AppEngine {
    let app: any App

    let renderer: RenderEngine
    lazy var focusEngine = FocusEngine()
    lazy var treeEngine: TreeEngine = TreeEngine(app: self.app)

    init(app: any App) {
        self.app = app
        renderer = RenderEngine()
    }

    func run() {
        // Listen to user input and execute it on different thread
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            while let self {
                if let key = Terminal.getKeyPress() {
                    self.focusEngine.processInput(key)
                }
            }
        }

        // Since currently we are not updating the tree -- this can be called only once
        focusEngine.calculateFocusableNodes(fromNode: treeEngine.rootNode)
        while true {
            renderer.render(fromNode: treeEngine.rootNode)

            // TODO: Not good idea
            usleep(100_000)  // Sleep for 100ms
        }
    }
}

class TreeEngine {
    let app: any App
    lazy var rootNode = buildTree(fromRootView: app)

    init(app: any App) {
        self.app = app
    }

    func buildTree(fromRootView rootView: some App) -> Node {
        // Special parent node
        let screen = Screen { rootView }
        guard let screenNode = screen.buildNode() else {
            fatalError("Unable to crease a screenNode")
        }

        for childView in screen.childViews() {
            _buildTree(fromView: childView, parentNode: screenNode)
        }

        return screenNode
    }

    private func _buildTree(fromView view: any View, parentNode: Node) {
        // The view can be custom container view declared by client or a leaf view which can be node builder
        // If its custom view just call buildTree on the body
        guard let nodeBuilder = view as? NodeBuilder else {
            _buildTree(fromView: view.body, parentNode: parentNode)
            return
        }

        var nextParentNode = parentNode
        if let node = nodeBuilder.buildNode() {
            parentNode.addChild(node)
            nextParentNode = node
        }

        for childView in nodeBuilder.childViews() {
            _buildTree(fromView: childView, parentNode: nextParentNode)
        }
    }
}

class FocusEngine {
    private(set) var focusedNode: Node? {
        willSet {
            focusedNode?.focused = false
        }
        didSet {
            focusedNode?.focused = true
        }
    }
    private var focusableNodes: [Node] = []  // Strong, really?

    func processInput(_ key: String) {
        // is tab
        if key == "\t" {
            jumpToNextFocusableNode()
        } else if key == " " {
            activateFocusedNode()
        }
    }

    private func jumpToNextFocusableNode() {
        guard !focusableNodes.isEmpty else { return }

        if let currentFocusedIndex = focusableNodes.firstIndex(where: { $0 === focusedNode }) {
            let nextIndex = (currentFocusedIndex + 1) % focusableNodes.count
            focusedNode = focusableNodes[nextIndex]
        } else {
            focusedNode = focusableNodes.first
        }
    }

    private func activateFocusedNode() {
        focusedNode?.activate()
    }

    // Empties the focusable nodes
    // Do this after update to render tree is expected
    func purge() {
        focusableNodes = []
    }

    // Do this when render tree is complete
    func calculateFocusableNodes(fromNode: Node) {
        purge()
        _calculateFocusableNodes(fromNode: fromNode)
    }

    // Doing DFS which is not idea
    // We should search according to screen layout i.e. how user is seeing them
    private func _calculateFocusableNodes(fromNode node: Node) {
        if node.focusable {
            focusableNodes.append(node)
        }

        for childNode in node.children {
            _calculateFocusableNodes(fromNode: childNode)
        }
    }
}
