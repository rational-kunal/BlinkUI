class RenderContext {
    fileprivate let terminal: Terminal

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
