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
        } else if key == "\u{1B}[Z" {  // "shift + tab"
            jumpToPreviousFocusableNode()
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

    private func jumpToPreviousFocusableNode() {
        guard !focusableNodes.isEmpty else { return }

        if let currentFocusedIndex = focusableNodes.firstIndex(where: { $0 === focusedNode }) {
            let previousIndex =
                (currentFocusedIndex - 1 + focusableNodes.count) % focusableNodes.count
            focusedNode = focusableNodes[previousIndex]
        } else {
            focusedNode = focusableNodes.last
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
        let previouslyFocusedViewId = focusedNode?.viewIdentifier
        purge()
        _calculateFocusableNodes(fromNode: fromNode)
        let focusedNodeFromNewTree = focusableNodes.first {
            $0.viewIdentifier == previouslyFocusedViewId
        }
        if focusedNode !== focusedNodeFromNewTree {
            self.focusedNode = focusedNodeFromNewTree
        }
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
