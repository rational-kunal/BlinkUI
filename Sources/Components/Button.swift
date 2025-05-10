public struct Button<Label>: View where Label: View {
    let label: Label
    let action: () -> Void

    init(action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
        self.action = action
        self.label = label()
    }
}
extension Button: NodeBuilder {
    func buildNode() -> Node? {
        return ButtonNode(view: self)
    }

    func childViews() -> [any View] {
        return [VStack { label }]
    }
}

class ButtonNode<Label: View>: Node {
    var buttonView: Button<Label> {
        guard let view = view as? Button<Label> else {
            fatalError("ButtonNode can only be used with Button")
        }
        return view
    }

    init(view: Button<Label>) {
        super.init(view: view)
        focusable = true
    }

    override func activate() {
        buttonView.action()
    }
}
extension ButtonNode: RenderableNode {
    func proposeViewSize(inSize: Size) -> Size {
        assert(renderableChildren.count == 1)
        let labelNode = renderableChildren[0]
        let labelSize = labelNode.proposeViewSize(inSize: inSize)

        // Add 1 for borders
        return (width: labelSize.width + 2, height: labelSize.height + 2)
    }

    func render(context: RenderContext, start: Point, size: Size) {
        // TODO: Make this more flexible ???
        // THe focusable rendering should not be responsibility of the element
        // Render border
        context.terminal.draw(x: start.x, y: start.y, symbol: focused ? "╔" : "┌")
        context.terminal.draw(x: start.x + size.width - 1, y: start.y, symbol: focused ? "╗" : "┐")
        context.terminal.draw(x: start.x, y: start.y + size.height - 1, symbol: focused ? "╚" : "└")
        context.terminal.draw(
            x: start.x + size.width - 1, y: start.y + size.height - 1, symbol: focused ? "╝" : "┘")

        for x in (start.x + 1)..<(start.x + size.width - 1) {
            context.terminal.draw(x: x, y: start.y, symbol: focused ? "═" : "─")
            context.terminal.draw(x: x, y: start.y + size.height - 1, symbol: focused ? "═" : "─")
        }
        for y in (start.y + 1)..<(start.y + size.height - 1) {
            context.terminal.draw(x: start.x, y: y, symbol: focused ? "║" : "│")
            context.terminal.draw(x: start.x + size.width - 1, y: y, symbol: focused ? "║" : "│")
        }

        // Render label
        self.renderableChildren.first?.render(
            context: context, start: (start.x + 1, start.y + 1),
            size: (size.width - 2, size.height - 2))
    }
}
