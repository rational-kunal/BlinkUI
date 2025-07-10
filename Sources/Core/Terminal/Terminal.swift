import Foundation
import os

private let logger = Logger(subsystem: "com.rational.blinkui", category: "Terminal")

class Terminal {

    // MARK: - Canvas
    private(set) var canvas: [[Pixel]] = TerminalHelper.makeCanvas()
    var canvasWidth: Int {
        canvas[0].count
    }
    var canvasHeight: Int {
        canvas.count
    }

    init() {
        TerminalHelper.enableAlternateScreen()
        TerminalHelper.hideCursor()
        TerminalHelper.enableRawMode()
    }

    func stop() {
        TerminalHelper.disableRawMode()
        TerminalHelper.showCursor()
        TerminalHelper.disableAlternateScreen()
    }

    func update() {
        canvas = TerminalHelper.makeCanvas()
    }

    // Renders the canvas / frame on the terminal
    func render() {
        TerminalHelper.moveCursor(x: 0, y: 0)
        var lastFg: Color = .default
        var lastBg: Color = .default
        var lastCharStyle: CharStyle = .none
        for row in canvas {
            for pixel in row {
                if pixel.fgColor != lastFg {
                    print(pixel.fgColor.ansiForeground, terminator: "")
                    lastFg = pixel.fgColor
                }
                if pixel.bgColor != lastBg {
                    print(pixel.bgColor.ansiBackground, terminator: "")
                    lastBg = pixel.bgColor
                }
                if pixel.charStyle != lastCharStyle {
                    print(pixel.charStyle.ansiCode, terminator: "")
                    lastCharStyle = pixel.charStyle
                }
                print(pixel.char, terminator: "")
            }
            print("\u{001B}[0m")  // Reset at end of line
            lastFg = .default
            lastBg = .default
            lastCharStyle = .none
        }
        fflush(stdout)
    }

    // Draws the symbol at the given position with color and charStyle
    func draw(
        x: Int, y: Int,
        symbol: Character? = nil,
        fgColor: Color? = nil, bgColor: Color? = nil,
        charStyle: CharStyle? = nil
    ) {
        guard x >= 0, x < canvasWidth, y >= 0, y < canvasHeight else {
            logger.error("Invalid coordinates: \(x), \(y)")
            return
        }
        var p = canvas[y][x]
        if let symbol {
            p.char = symbol
        }
        if let fgColor {
            p.fgColor = fgColor
        }
        if let bgColor {
            p.bgColor = bgColor
        }
        if let charStyle {
            p.charStyle = charStyle
        }
        canvas[y][x] = p
    }
}

extension Terminal {
    static func getKeyPress() -> String? {
        var buffer = [UInt8](repeating: 0, count: 3)
        let readBytes = read(STDIN_FILENO, &buffer, 3)

        if readBytes == 1 {
            return String(UnicodeScalar(buffer[0]))
        } else if readBytes > 1 {
            return buffer.prefix(readBytes).map { String(UnicodeScalar($0)) }.joined()
        }
        return nil
    }
}
