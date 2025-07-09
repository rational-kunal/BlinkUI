import SwiftUI

extension View {
    public func bold(_ isActive: Bool = true) -> some View {
        modifier(
            CharStyleModifier(
                charStyle: isActive ? .bold : [],
                excludeCharStyle: isActive ? [] : .bold
            ))
    }

    public func italic(_ isActive: Bool = true) -> some View {
        modifier(
            CharStyleModifier(
                charStyle: isActive ? .italic : [],
                excludeCharStyle: isActive ? [] : .italic
            ))
    }

    public func underline(_ isActive: Bool = true) -> some View {
        modifier(
            CharStyleModifier(
                charStyle: isActive ? .underline : [],
                excludeCharStyle: isActive ? [] : .underline
            ))
    }

    public func strikethrough(_ isActive: Bool = true) -> some View {
        modifier(
            CharStyleModifier(
                charStyle: isActive ? .strikethrough : [],
                excludeCharStyle: isActive ? [] : .strikethrough
            ))
    }
}

struct CharStyleModifier: ViewModifier {
    let charStyle: CharStyle
    let excludeCharStyle: CharStyle

    init(charStyle: CharStyle = [], excludeCharStyle: CharStyle = []) {
        self.charStyle = charStyle
        self.excludeCharStyle = excludeCharStyle
    }

    func body(content: Content) -> some View {
        CharStyleView(content: content, charStyle: charStyle, excludeCharStyle: excludeCharStyle)
    }
}

private struct CharStyleView<Content: View>: View {
    let content: Content
    let charStyle: CharStyle
    let excludeCharStyle: CharStyle
}

extension CharStyleView: NodeBuilder {
    func buildNode(viewIdentifier: ViewIdentifier) -> Node {
        CharStyleNode(view: self, viewIdentifier: viewIdentifier)
    }

    func childViews() -> [any View] {
        [content]
    }
}

private class CharStyleNode<Content: View>: Node {
    var charStyleView: CharStyleView<Content> {
        guard let view = view as? CharStyleView<Content> else {
            fatalError("CharStyleNode can only be used with char style views")
        }
        return view
    }

    init(view: CharStyleView<Content>, viewIdentifier: ViewIdentifier) {
        super.init(view: view, viewIdentifier: viewIdentifier)
        super.charStyle = view.charStyle
    }

    override var charStyle: CharStyle {
        get { super.charStyle }
        set {
            var value = newValue
            value.remove(charStyleView.excludeCharStyle)
            super.charStyle = value
        }
    }
}
