extension View {
    func frame(width: Int? = nil, height: Int? = nil) -> some View {
        modifier(FrameModifier(width: width, height: height))
    }
}

private struct FrameModifier: ViewModifier {
    let width: Int?
    let height: Int?

    public func body(content: ModifiedContent<Self>) -> some View {
        FrameView(content: content, width: width, height: height)
    }
}

private struct FrameView<Content: View>: View {
    let content: Content
    let width: Int?
    let height: Int?

    public var body: Never { fatalError("Primitive view") }
}

extension FrameView: NodeBuilder {
    fileprivate func buildNode(_ node: Node) {
        let selfNode = FrameNode(view: self)
        node.addChild(selfNode)
        if let content = content as? NodeBuilder {
            content.buildNode(selfNode)
        }  //else {
        // (content as any View).body.buildNode(selfNode)
        // }
    }
}

private class FrameNode<Content: View>: Node {
    var frameView: FrameView<Content> {
        guard let frameView = view as? FrameView<Content> else {
            fatalError("FrameNode can only be used with Frame views")
        }
        return frameView
    }

    init(view: FrameView<Content>) {
        super.init(view: view)
    }

    override func interinsizeIn(_ size: Size) -> Size {
        assert(self.children.count == 1)
        guard let child = children.first else {
            return (width: size.width, height: size.height)
        }

        return child.interinsizeIn(
            (width: frameView.width ?? size.width, height: frameView.height ?? size.height))
    }

    override func render(context: RenderContext, start: Point, size: Size) {
        assert(self.children.count == 1)
        guard let child = children.first else {
            return
        }

        child.render(context: context, start: start, size: size)
    }
}
