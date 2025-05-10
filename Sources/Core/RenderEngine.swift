class RenderEngine {
    lazy var terminal: Terminal = Terminal()
    lazy var context: RenderContext = RenderContext(terminal: terminal)

    func render(fromNode node: RenderableNode) {
        terminal.update()  // Update terminal canvas
        defer {
            // Flush output on terminal
            terminal.render()
        }

        let size = node.proposeViewSize(
            inSize: (width: terminal.canvasWidth, height: terminal.canvasHeight))

        let start = Point(
            x: (terminal.canvasWidth - size.width) / 2, y: (terminal.canvasHeight - size.height) / 2
        )

        node.render(context: context, start: start, size: size)
    }
}
