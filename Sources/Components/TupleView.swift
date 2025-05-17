import os

private let logger = Logger(subsystem: "com.rational.blinkui", category: "TupleView")

struct TupleView<each T>: View {
    let content: (repeat each T)

    init(_ content: (repeat each T)) {
        self.content = content
    }
}

extension TupleView: NodeBuilder {
    func childViews() -> [any View] {
        var childViews = [any View]()
        for child in repeat each content {
            if let childView = child as? (any View) {
                childViews.append(childView)
            }
        }

        return childViews
    }
}
