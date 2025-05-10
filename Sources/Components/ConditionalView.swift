struct ConditionalView<T, F>: View where T: View, F: View {
    enum ViewCase {
        case truthy, falsy
    }
    let viewCase: ViewCase
    let content: any View

    private init(viewCase: ViewCase, content: any View) {
        self.viewCase = viewCase
        self.content = content
    }
    static func truthy(@ViewBuilder content: () -> T) -> Self {
        return ConditionalView(viewCase: .truthy, content: content())
    }

    static func falsy(@ViewBuilder content: () -> F) -> Self {
        return ConditionalView(viewCase: .falsy, content: content())
    }
}
extension ConditionalView: NodeBuilder {
    func childViews() -> [any View] {
        if viewCase == .truthy {
            return [content, EmptyView()]
        } else if viewCase == .falsy {
            return [EmptyView(), content]
        }
        return []
    }
}

class ConditionalNode<T, F>: Node where T: View, F: View {
    static func == (lhs: ConditionalNode, rhs: ConditionalNode) -> Bool {
        guard let lhsConditionalView = lhs.view as? ConditionalView<T, F>,
            let rhsConditionalView = rhs.view as? ConditionalView<T, F>
        else {
            fatalError("Expected conditional view for \(lhs) and \(rhs)")
        }

        return lhs.viewIdentifier == rhs.viewIdentifier
            && lhsConditionalView.viewCase == rhsConditionalView.viewCase
    }
}
