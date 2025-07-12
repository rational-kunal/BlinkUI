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
        return SetEnvironmentNode(viewIdentifier: viewIdentifier, keyPath: keyPath, value: value)
    }

    func childViews() -> [any View] {
        [content]
    }
}

private class SetEnvironmentNode<V>: Node {
    let keyPath: WritableKeyPath<EnvironmentValues, V>
    let value: V

    init(viewIdentifier: ViewIdentifier, keyPath: WritableKeyPath<EnvironmentValues, V>, value: V) {
        self.keyPath = keyPath
        self.value = value
        super.init(viewIdentifier: viewIdentifier)
    }

    override func getEnvironmentValues() -> EnvironmentValues {
        if let environmentValues {
            return environmentValues
        }

        var environmentValues = super.getEnvironmentValues()
        environmentValues[keyPath: keyPath] = value
        self.environmentValues = environmentValues
        return environmentValues
    }
}
