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
    func buildNode() -> Node? {
        // This view itself is not that much imp so attach children directly to parent
        return nil
    }

    func childViews() -> [any View] {
        let mirror = Mirror(reflecting: content)
        return mirror.children.compactMap { (label, child) in
            guard let child = child as? any View else {
                logger.error("\(String(describing: label)) does not conform to NodeBuilder or View")
                return nil
            }

            return child
        }
    }
}
