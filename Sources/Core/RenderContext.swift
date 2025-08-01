class RenderContext {
    fileprivate let terminal: Terminal

    // This is used to determine if the render engine should render the node
    // Set this to true then in next cycle we will render the screen
    var shouldRender: Bool = true

    init(terminal: Terminal) {
        self.terminal = terminal
    }
}

extension Node {
    //
    // if nil is passed for symbol that usually means that we need to render the styling information
    func draw(with context: RenderContext, at atPoint: Point, symbol: Character? = nil) {
        context.terminal.draw(
            x: atPoint.x, y: atPoint.y,
            symbol: symbol,
            fgColor: foregroundColor, bgColor: backgroundColor,
            charStyle: charStyle)
    }
}
