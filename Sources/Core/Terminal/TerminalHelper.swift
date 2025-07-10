import os

struct TerminalHelper {
    static func windowSize() -> (width: Int, height: Int) {
        if IsDebug() {
            return (30, 15)
        } else {
            var ws = winsize()
            _ = ioctl(STDOUT_FILENO, TIOCGWINSZ, &ws)
            return (Int(ws.ws_col), Int(ws.ws_row) - 1)
        }
    }

    static func makeCanvas() -> [[Pixel]] {
        let (width, height) = windowSize()
        return Array(repeating: Array(repeating: Pixel.blank, count: width), count: height)
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
