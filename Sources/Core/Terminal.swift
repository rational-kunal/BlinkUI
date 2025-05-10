import Foundation
import os

private let logger = Logger(subsystem: "com.rational.blinkui", category: "Terminal")

class Terminal {

    // MARK: - Canvas
    private(set) var canvas: [[Character]] = TerminalHelper.makeCanvas()
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
        // Re-creating the canvas each time which does not seem like a good idea
        canvas = TerminalHelper.makeCanvas()
    }

    // Renders the canvas / frame on the terminal
    func render() {
        TerminalHelper.moveCursor(x: 0, y: 0)
        for row in canvas {
            print(String(row))
        }
        fflush(stdout)
    }

    // Draws the symbol at the given position
    func draw(x: Int, y: Int, symbol: Character) {
        guard x >= 0, x < canvasWidth, y >= 0, y < canvasHeight else {
            logger.error("Invalid coordinates: \(x), \(y)")
            return
        }
        canvas[y][x] = symbol
    }
}

extension Terminal {
    static func getKeyPress() -> String? {
        var buffer = [UInt8](repeating: 0, count: 3)
        let readBytes = read(STDIN_FILENO, &buffer, 3)

        if readBytes == 1 {
            return String(UnicodeScalar(buffer[0]))
        }
        return nil
    }
}

private struct TerminalHelper {
    static func windowSize() -> (width: Int, height: Int) {
        if IsDebug() {
            return (30, 15)
        } else {
            var ws = winsize()
            _ = ioctl(STDOUT_FILENO, TIOCGWINSZ, &ws)
            return (Int(ws.ws_col), Int(ws.ws_row) - 1)
        }
    }

    // Create blank 2d buffer of blank characters
    static func makeCanvas() -> [[Character]] {
        let (width, height) = windowSize()
        return Array(repeating: Array(repeating: " ", count: width), count: height)
    }

    // Enable alternate screen buffer (prevents scrolling & flickering)
    static func enableAlternateScreen() {
        print("\u{001B}[?1049h", terminator: "")
    }

    // Disable alternate screen buffer on exit
    static func disableAlternateScreen() {
        print("\u{001B}[?1049l", terminator: "")
    }

    // Hide cursor for better visual experience
    static func hideCursor() {
        print("\u{001B}[?25l", terminator: "")
    }

    // Show cursor again when exiting
    static func showCursor() {
        print("\u{001B}[?25h", terminator: "")
    }

    // Move the cursor to a specific position
    static func moveCursor(x: Int, y: Int) {
        print("\u{001B}[\(y);\(x)H", terminator: "")
    }

    // Clear the screen
    static func clearScreen() {
        print("\u{001B}[2J", terminator: "")
    }

    // Enable non-blocking input
    static func enableRawMode() {
        var raw = termios()
        tcgetattr(STDIN_FILENO, &raw)
        raw.c_lflag &= ~tcflag_t(ECHO | ICANON)  // Disable echo & line buffering
        raw.c_cc.0 = 1  // Min character read
        raw.c_cc.1 = 0  // No timeout
        tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw)
    }

    // Disable non-blocking input
    static func disableRawMode() {
        var term = termios()
        tcgetattr(STDIN_FILENO, &term)
        term.c_lflag |= tcflag_t(ECHO | ICANON)
        tcsetattr(STDIN_FILENO, TCSAFLUSH, &term)
    }
}
