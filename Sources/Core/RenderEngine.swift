class RenderEngine {
    let rootView: (any View)!
    lazy var terminal: Terminal = Terminal()
    lazy var context: RenderContext = RenderContext(terminal: terminal)
    lazy var viewHierarchyEngine: ViewHeirarchyEngine = ViewHeirarchyEngine(rootView: rootView)

    init(rootView: some View) {
        self.rootView = VStack { rootView }
    }

    func updateAndRender() {
        terminal.update()  // Update terminal canvas
        defer {
            // Flush output on terminal
            terminal.render()
        }

        let size = viewHierarchyEngine.root.interinsizeIn(
            (width: terminal.canvasWidth, height: terminal.canvasHeight))

        let start = Point(
            x: (terminal.canvasWidth - size.width) / 2, y: (terminal.canvasHeight - size.height) / 2
        )

        viewHierarchyEngine.root.render(context: context, start: start, size: size)
    }
}
