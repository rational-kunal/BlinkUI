import SwiftUI

extension View {
    public func border(style: BorderStyle = .solid) -> some View {
        modifier(BorderModifier(style: style))
    }
}

public enum BorderStyle {
    case solid
    case dashed
    case rounded
    case double
}

private struct BorderModifier: ViewModifier {
    let style: BorderStyle

    func body(content: Content) -> some View {
        BorderView(content: content, style: style)
    }
}

private struct BorderView<Content>: View where Content: View {
    let content: Content
    let style: BorderStyle
}
extension BorderView: NodeBuilder {
    func buildNode(viewIdentifier: ViewIdentifier) -> Node {
        BorderNode(view: self, viewIdentifier: viewIdentifier)
    }

    func childViews() -> [any View] {
        [VStack { content }]
    }
}

private class BorderNode<Content>: Node where Content: View {
    var borderView: BorderView<Content> {
        guard let borderView = view as? BorderView<Content> else {
            fatalError("BorderNode can only be used with Border views")
        }
        return borderView
    }

    init(view: BorderView<Content>, viewIdentifier: ViewIdentifier) {
        super.init(view: view, viewIdentifier: viewIdentifier)
    }
}

extension BorderNode: RenderableNode {
    func proposeViewSize(inSize: Size) -> Size {
        assert(renderableChildren.count == 1, "There should be only one renderable child")
        let renderableChild = renderableChildren[0]

        let proposedChildViewSize = renderableChild.proposeViewSize(inSize: inSize)

        let additionalWidth = 2
        let additionalHeight = 2
        let proposedSize = (
            width: proposedChildViewSize.width + additionalWidth,
            height: proposedChildViewSize.height + additionalHeight
        )

        return (width: max(proposedSize.width, 0), height: max(proposedSize.height, 0))
    }

    func render(context: RenderContext, start: Point, size: Size) {
        assert(renderableChildren.count == 1, "There should be only one renderable child")
        let renderableChild = renderableChildren[0]

        let borderSymbols = symbols(for: borderView.style)

        context.terminal.draw(x: start.x, y: start.y, symbol: borderSymbols.topLeft)
        context.terminal.draw(
            x: start.x + size.width - 1, y: start.y, symbol: borderSymbols.topRight)
        context.terminal.draw(
            x: start.x, y: start.y + size.height - 1, symbol: borderSymbols.bottomLeft)
        context.terminal.draw(
            x: start.x + size.width - 1, y: start.y + size.height - 1,
            symbol: borderSymbols.bottomRight)

        for x in (start.x + 1)..<(start.x + size.width - 1) {
            context.terminal.draw(x: x, y: start.y, symbol: borderSymbols.horizontal)
            context.terminal.draw(
                x: x, y: start.y + size.height - 1, symbol: borderSymbols.horizontal)
        }

        for y in (start.y + 1)..<(start.y + size.height - 1) {
            context.terminal.draw(x: start.x, y: y, symbol: borderSymbols.vertical)
            context.terminal.draw(x: start.x + size.width - 1, y: y, symbol: borderSymbols.vertical)
        }

        let adjustedStart = Point(x: start.x + 1, y: start.y + 1)
        let adjustedSize = Size(width: size.width - 2, height: size.height - 2)

        renderableChild.render(context: context, start: adjustedStart, size: adjustedSize)
    }

    private func symbols(for style: BorderStyle) -> (
        topLeft: Character, topRight: Character, bottomLeft: Character, bottomRight: Character,
        horizontal: Character, vertical: Character
    ) {
        switch style {
        case .solid:
            return ("┌", "┐", "└", "┘", "─", "│")
        case .dashed:
            return ("┌", "┐", "└", "┘", "╌", "╎")
        case .rounded:
            return ("╭", "╮", "╰", "╯", "─", "│")
        case .double:
            return ("╔", "╗", "╚", "╝", "═", "║")
        }
    }
}
