import os

class AppEngine {
    let renderer: RenderEngine
    lazy var focusEngine = FocusEngine()

    init(app: any App) {
        renderer = RenderEngine(rootView: app.body)
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
        focusEngine.calculateFocusableNodes(fromNode: renderer.root)
        while true {
            renderer.updateAndRender()

            // TODO: Not good idea
            usleep(100_000)  // Sleep for 100ms
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
