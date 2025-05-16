extension View {
    func environment<V>(_ keyPath: WritableKeyPath<EnvironmentValues, V>, _ value: V) -> some View {
        modifier(SetEnvironmentModifier(keyPath: keyPath, value: value))
    }
}

private struct SetEnvironmentModifier<V>: ViewModifier {
    let keyPath: WritableKeyPath<EnvironmentValues, V>
    let value: V

    func body(content: Content) -> some View {
        SetEnvironmentView(content: content, keyPath: keyPath, value: value)
    }
}

private struct SetEnvironmentView<Content, V>: View where Content: View {
    let content: Content
    let keyPath: WritableKeyPath<EnvironmentValues, V>
    let value: V
}

extension SetEnvironmentView: NodeBuilder {
    func buildNode(viewIdentifier: ViewIdentifier) -> Node {
        return SetEnvironmentNode(view: self, viewIdentifier: viewIdentifier)
    }

    func childViews() -> [any View] {
        [content]
    }
}

private class SetEnvironmentNode<Content, V>: Node where Content: View {
    var environmentView: SetEnvironmentView<Content, V> {
        guard let environmentView = view as? SetEnvironmentView<Content, V> else {
            fatalError("SetEnvironmentNode can only be used with environment views")
        }
        return environmentView
    }

    init(view: SetEnvironmentView<Content, V>, viewIdentifier: ViewIdentifier) {
        super.init(view: view, viewIdentifier: viewIdentifier)
    }

    override func getEnvironmentValues() -> EnvironmentValues {
        if let environmentValues {
            return environmentValues
        }

        var environmentValues = super.getEnvironmentValues()
        environmentValues[keyPath: environmentView.keyPath] = environmentView.value
        self.environmentValues = environmentValues
        return environmentValues
    }
}
