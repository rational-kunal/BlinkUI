private let Ellipses: String = "…"

public struct Text: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }
}

extension Text: NodeBuilder {
    func buildNode(viewIdentifier: ViewIdentifier) -> Node {
        TextNode(view: self, viewIdentifier: viewIdentifier)
    }

    func childViews() -> [any View] {
        return []
    }
}

class TextNode: Node {
    var textView: Text {
        guard let textView = view as? Text else {
            fatalError("TextNode can only be used with Text views")
        }
        return textView
    }
    lazy var text: String = { textView.text }()

    init(view: Text, viewIdentifier: ViewIdentifier) {
        super.init(view: view, viewIdentifier: viewIdentifier)
    }
}
extension TextNode: RenderableNode {
    // TODO: Better word wrapping algorithm
    func proposeViewSize(inSize: Size) -> Size {
        guard inSize.height > 0 && inSize.width > 0 else {
            return (width: 0, height: 0)  // Cant render so return empty frames
        }

        if inSize.width >= textView.text.count {  // Enough width to have the text in one height
            return (width: textView.text.count, height: 1)
        }

        let words: [String] = text.split(separator: " ").map { String($0) }

        if words.count == 1 {
            // If the text is a single word and doesn't fit within the available width,
            // return the maximum width and handle truncation with ellipses during rendering.
            return (width: inSize.width, height: 1)
        }

        var maxWidth = 0
        var height = 1
        var currentWidth = 0
        for (index, word) in words.enumerated() {
            let space = index == 0 ? 0 : 1  // No space for first word
            let nextWordWidth = word.count + space
            if currentWidth + nextWordWidth > inSize.width {
                height += 1
                maxWidth = max(maxWidth, currentWidth)
                currentWidth = nextWordWidth  // Fill next row with the width -- TODO: case where the word width is larger than the current width
            } else {
                currentWidth += nextWordWidth
            }

            if height > inSize.height {
                currentWidth = 1
                break
            }
        }

        maxWidth = max(maxWidth, currentWidth)
        return (width: min(maxWidth, inSize.width), height: min(height, inSize.height))
    }

    func render(context: RenderContext, start: Point, size: Size) {
        guard size.height > 0 && size.width > 0 else {
            return  // Cant render
        }

        if size.width >= textView.text.count {  // Enough width to have the text in one height
            for (index, char) in textView.text.enumerated() {
                context.terminal.draw(x: start.x + index, y: start.y, symbol: char)
            }
            return
        }

        let words: [String] = text.split(separator: " ").map { String($0) }

        if words.count == 1 {
            for (index, char) in textView.text.enumerated() {
                context.terminal.draw(x: start.x + index, y: start.y, symbol: char)
            }
            return
        }

        var currentWidth = 0
        var currentHeight = 0
        for (index, word) in words.enumerated() {
            let space = index == 0 ? 0 : 1  // No space for the first word
            let nextWordWidth = word.count + space
            if currentWidth + nextWordWidth > size.width {
                currentHeight += 1
                currentWidth = 0
                if currentHeight >= size.height {
                    // Truncate with ellipses if height exceeds available space
                    let truncatedWord = word.prefix(size.width - 1) + Ellipses
                    for (charIndex, char) in truncatedWord.enumerated() {
                        context.terminal.draw(
                            x: start.x + charIndex, y: start.y + currentHeight, symbol: char)
                    }
                    break
                }
            }

            if currentHeight < size.height {
                for (charIndex, char) in word.enumerated() {
                    context.terminal.draw(
                        x: start.x + currentWidth + charIndex, y: start.y + currentHeight,
                        symbol: char)
                }
                currentWidth += word.count
                // Draw the word
                if space > 0 {
                    context.terminal.draw(
                        x: start.x + currentWidth, y: start.y + currentHeight, symbol: " ")
                    currentWidth += 1
                }
            }
        }
    }
}
