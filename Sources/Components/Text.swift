public struct Text: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }
}

extension Text: NodeBuilder {
    func buildNode() -> Node? {
        TextNode(view: self)
    }
}

class TextNode: Node {
    var textView: Text {
        guard let textView = view as? Text else {
            fatalError("TextNode can only be used with Text views")
        }
        return textView
    }

    init(view: Text) {
        super.init(view: view)
    }
}
extension TextNode: RenderableNode {
    func proposeViewSize(inSize: Size) -> Size {
        // For now the width is the length of the text
        // TODO: Update this logic for edge cases
        // - Width is smaller than the text length
        // - Ellipses
        // - Multiline text
        return (width: textView.text.count, height: 1)
    }

    func render(context: RenderContext, start: Point, size: Size) {
        // Text should be in the center so add the required padding in the start
        let padding = (size.width - textView.text.count) / 2
        var x = start.x
        for _ in 0..<padding {
            context.terminal.draw(x: x, y: start.y, symbol: " ")
            x += 1
        }
        for (index, char) in textView.text.enumerated() {
            context.terminal.draw(x: x + index, y: start.y, symbol: char)
        }
    }
}
