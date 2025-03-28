import os

private let logger = Logger(subsystem: "com.rational.blinkui", category: "TupleView")

public struct TupleView<T>: View {
    let content: T

    public var body: Never { fatalError("Cannot evaluate body of primitive view") }

    init(_ content: T) {
        self.content = content
    }
}
extension TupleView: NodeBuilder {
    func buildNode(_ node: Node) {
        let mirror = Mirror(reflecting: content)

        // This view iteself is not that much imp so attach children directly to parent
        for child in mirror.children {
            if let childNode = child.value as? NodeBuilder {
                childNode.buildNode(node)
            } else if let childView = child.value as? any View {
                childView.buildNode(node)
            } else {
                logger.error(
                    "\(String(describing: child.value)) does not conform to NodeBuilder or View"
                )
            }
        }
    }
}
