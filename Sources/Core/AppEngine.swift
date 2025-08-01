import os

public class AppEngine {
    let app: any App

    let renderer: RenderEngine
    lazy var focusEngine = FocusEngine()
    lazy var treeEngine = TreeEngine(app: self.app)

    init(app: any App) {
        self.app = app
        renderer = RenderEngine()
    }

    func run() {
        // Listen to user input and execute it on different thread
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            while let self {
                if let key = Terminal.getKeyPress() {
                    self.focusEngine.processInput(key)
                }
            }
        }

        SignalHandler.onUserExit = { [weak self] in
            self?.exit()
        }
        SignalHandler.setup()

        // Since currently we are not updating the tree -- this can be called only once
        while true {
            focusEngine.calculateFocusableNodes(fromNode: treeEngine.rootNode)
            renderer.render(fromNode: treeEngine.renderableRootNode)

            // TODO: Not good idea
            usleep(100_000)  // Sleep for 100ms
        }
    }

    func exit() {
        app.userWillExit()
        renderer.cleanUp()
        _stdlib.exit(0)
    }
}

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
