import os

class SignalHandler {
    nonisolated(unsafe) fileprivate static var onUserExit: () -> Void = {}

    static func setup() {
        let signalHandler: @convention(c) (Int32) -> Void = { _ in
            SignalHandler.onUserExit()
        }

        signal(SIGINT, signalHandler)
        signal(SIGTERM, signalHandler)
    }
}

extension AppEngine {
    func setUpExitSignal() {
        SignalHandler.onUserExit = { [weak self] in
            guard let self else { return }
            onExitSignal()
        }
        SignalHandler.setup()
    }
}
