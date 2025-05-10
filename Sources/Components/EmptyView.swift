public struct EmptyView: View {}
extension EmptyView: NodeBuilder {
    func buildNode() -> Node? {
        return EmptyNode(view: self)
    }
}
class EmptyNode: Node {}
