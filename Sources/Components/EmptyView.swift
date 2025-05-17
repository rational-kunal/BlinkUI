public struct EmptyView: View {}
extension EmptyView: NodeBuilder {
    func buildNode(viewIdentifier: ViewIdentifier) -> Node {
        return EmptyNode(view: self, viewIdentifier: viewIdentifier)
    }

    func childViews() -> [any View] {
        return []
    }
}

class EmptyNode: Node {}
