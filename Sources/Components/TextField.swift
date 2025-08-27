public struct TextField: View {
    let placeholder: String
    let text: Binding<String>

    init(_ placeholder: String, _ text: Binding<String>) {
        self.placeholder = placeholder
        self.text = text
    }
}

extension TextField: NodeBuilder {
    func buildNode(viewIdentifier: ViewIdentifier) -> Node {
        TextFieldNode(viewIdentifier: viewIdentifier, placeholder: placeholder, text: text)
    }

    func childViews() -> [any View] { [] }
}

class TextFieldNode: Node {
    let placeholder: String
    let text: Binding<String>

    init(viewIdentifier: ViewIdentifier, placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self.text = text
        super.init(viewIdentifier: viewIdentifier)
        focusable = true
    }

    override var foregroundColor: Color? {
        get { focused ? super.foregroundColor : tertiaryColor }
        set { super.foregroundColor = newValue }
    }
    override var backgroundColor: Color? {
        get { focused ? tintColor : super.backgroundColor }
        set { super.backgroundColor = newValue }
    }

    override func userDidEnter(input: String) -> Bool {
        if input == "\u{7f}" || input == "\u{8}" {  // "backspace" or "delete"
            // If user pressed backspace remove last character
            if !text.wrappedValue.isEmpty {
                text.wrappedValue.removeLast()
            }
        } else {
            text.wrappedValue.append(contentsOf: input)
        }
        return true  // We are processing the input
    }
}

extension TextFieldNode: RenderableNode {
    func proposeViewSize(inSize: Size) -> Size {
        guard inSize.height > 0 && inSize.width > 0 else {
            return (width: 0, height: 0)  // Cant render so return empty frames
        }
        let textToShow = text.wrappedValue.count > 0 ? text.wrappedValue : placeholder

        return (width: inSize.width, height: 1)  // Currently we only support single line inputs
    }

    func render(context: RenderContext, start: Point, size: Size) {
        let textToShow = text.wrappedValue.count > 0 ? text.wrappedValue : placeholder

        for x in 0..<Int(size.width) {
            for y in 0..<Int(size.height) {
                draw(with: context, at: (start.x + x, start.y + y), symbol: " ")
            }
        }

        var currX = start.x
        let currY = start.y

        // show arrow if there is overflow
        let showArrow =
            if focused {
                text.wrappedValue.count > size.width - 1
            } else {
                textToShow.count > size.width
            }
        if showArrow {
            draw(with: context, at: (currX, currY), symbol: "←")
            currX += 1
        }

        // last "size.width - 1 / 2" length string
        let partOfTextThatAppears =
            if focused {
                text.wrappedValue.suffix(max(size.width - 2, 0))
            } else {
                textToShow.suffix(max(size.width - 1, 0))
            }
        for c in partOfTextThatAppears {
            draw(with: context, at: (currX, currY), symbol: c)
            currX += 1
        }

        // show cursor at last
        if focused {
            draw(with: context, at: (currX, currY), symbol: "█")
        }
    }
}
