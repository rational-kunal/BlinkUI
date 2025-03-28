struct Screen: View {
}
extension Screen: NodeBuilder {
    func buildNode(_ node: Node) {
        // Don't add node here, it should be added by the ViewHeirarchyEngine
    }
}
class ScreenNode: Node {
    override func interinsizeIn(_ size: Size) -> Size {
        assert(self.children.count == 1)
        return self.children.first?.interinsizeIn(size) ?? super.interinsizeIn(size)
    }
    override func render(context: RenderContext, start: Point, size: Size) {
        assert(self.children.count == 1)
        self.children.first?.render(context: context, start: start, size: size)
    }
}
