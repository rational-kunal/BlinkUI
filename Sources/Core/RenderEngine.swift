class RenderEngine {
    let rootView: (any View)!
    lazy var root: Node = ScreenNode(view: Screen())
    lazy var terminal: Terminal = Terminal()
    lazy var context: RenderContext = RenderContext(terminal: terminal)

    init(rootView: some View) {
        self.rootView = VStack { rootView }

        // Build initial node
        self.rootView.buildNode(self.root)
    }

    func updateAndRender() {
        terminal.update()  // Update terminal canvas
        defer {
            // Flush output on terminal
            terminal.render()
        }

        let size = root.interinsizeIn(
            (width: terminal.canvasWidth, height: terminal.canvasHeight))

        let start = Point(
            x: (terminal.canvasWidth - size.width) / 2, y: (terminal.canvasHeight - size.height) / 2
        )

        root.render(context: context, start: start, size: size)
    }
}
