public struct Button<Label>: View where Label: View {
    let label: Label
    let action: () -> Void

    init(action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
        self.action = action
        self.label = label()
    }

    init(_ title: String, action: @escaping () -> Void) where Label == Text {
        self.action = action
        self.label = Text("[\(title)]")
    }
}
extension Button: NodeBuilder {
    func buildNode(viewIdentifier: ViewIdentifier) -> Node {
        return ButtonNode(viewIdentifier: viewIdentifier, action: action)
    }

    func childViews() -> [any View] {
        return [VStack { label }]
    }
}

class ButtonNode: Node {
    let action: () -> Void

    init(viewIdentifier: ViewIdentifier, action: @escaping () -> Void) {
        self.action = action
        super.init(viewIdentifier: viewIdentifier)
        focusable = true
    }

    override var foregroundColor: Color? {
        get { focused ? super.foregroundColor : tintColor }
        set { super.foregroundColor = newValue }
    }
    override var backgroundColor: Color? {
        get { focused ? tintColor : super.backgroundColor }
        set { super.backgroundColor = newValue }
    }

    override func activate() {
        action()
    }
}
extension ButtonNode: RenderableNode {
    func proposeViewSize(inSize: Size) -> Size {
        assert(renderableChildren.count == 1)
        let labelNode = renderableChildren[0]
        let labelSize = labelNode.proposeViewSize(inSize: inSize)
        return (width: labelSize.width, height: labelSize.height)
    }

    func render(context: RenderContext, start: Point, size: Size) {
        for x in 0..<Int(size.width) {
            for y in 0..<Int(size.height) {
                draw(with: context, at: (start.x + x, start.y + y))
            }
        }

        // Render label
        self.renderableChildren.first?.render(
            context: context, start: start,
            size: size)
    }
}
