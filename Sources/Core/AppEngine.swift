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

        // Since currently we are not updating the tree -- this can be called only once
        while true {
            focusEngine.calculateFocusableNodes(fromNode: treeEngine.rootNode)
            renderer.render(fromNode: treeEngine.renderableRootNode)

            // TODO: Not good idea
            usleep(100_000)  // Sleep for 100ms
        }
    }
}
