struct ClientDefinedViewNodeBuilder: NodeBuilder {
    let clientDefinedView: any View
    func buildNode(viewIdentifier: ViewIdentifier) -> Node {
        return Node(viewIdentifier: viewIdentifier)
    }
    func childViews() -> [any View] {
        return [clientDefinedView.body]
    }
}
