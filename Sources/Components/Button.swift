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
        return ButtonNode(view: self, viewIdentifier: viewIdentifier)
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

    init(view: Button<Label>, viewIdentifier: ViewIdentifier) {
        super.init(view: view, viewIdentifier: viewIdentifier)
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
        return (width: labelSize.width, height: labelSize.height)
    }

    func render(context: RenderContext, start: Point, size: Size) {
        // TODO: Button tint color + background color support
        for x in 0..<Int(size.width) {
            for y in 0..<Int(size.height) {
                context.terminal.draw(
                    x: start.x + x, y: start.y + y,
                    fgColor: focused ? nil : self.tintColor,
                    bgColor: focused ? self.tintColor : nil)
            }
        }

        // Render label
        self.renderableChildren.first?.render(
            context: context, start: start,
            size: size)
    }
}
