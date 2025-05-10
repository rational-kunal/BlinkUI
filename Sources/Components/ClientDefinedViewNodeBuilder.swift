struct ClientDefinedViewNodeBuilder: NodeBuilder {
    let clientDefinedView: any View
    func buildNode() -> Node? {
        return Node(view: clientDefinedView)
    }
    func childViews() -> [any View] {
        return [clientDefinedView.body]
    }
}
