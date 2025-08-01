import os

public class AppEngine {
    struct Config {
        // Determines the target frames per second for the app engine.
        // The engine aims to render at this frame rate, evaluating each cycle if rendering is required.
        let framesPerSecond: Double = 10
    }

    let app: any App
    let config: Config

    let renderer: RenderEngine
    lazy var focusEngine = FocusEngine()
    lazy var treeEngine = TreeEngine(app: self.app, engine: self)

    lazy var userInputSource = DispatchSource.makeReadSource(
        fileDescriptor: STDIN_FILENO, queue: DispatchQueue.global(qos: .userInteractive))

    init(app: any App, config: Config = Config()) {
        self.app = app
        self.config = config
        renderer = RenderEngine()
    }

    func run() {
        setUpInput()
        setUpExitSignal()
        setUpPoll()
    }

    func onUserInput(_ rawUserInput: String) {
        focusEngine.processInput(rawUserInput)
        setShouldRender()
    }

    func onExitSignal() {
        app.userWillExit()
        renderer.cleanUp()
        _stdlib.exit(0)
    }

    func loop() {
        guard shouldRender() else { return }
        defer { unsetShouldRender() }

        focusEngine.calculateFocusableNodes(fromNode: treeEngine.rootNode)
        renderer.render(fromNode: treeEngine.renderableRootNode)
    }
}

protocol AppEngineExtension: AnyObject {
    func shouldRender() -> Bool
    func setShouldRender()
    func unsetShouldRender()
}
extension AppEngine: AppEngineExtension {
    func shouldRender() -> Bool {
        renderer.context.shouldRender
    }

    func setShouldRender() {
        renderer.context.shouldRender = true
    }

    func unsetShouldRender() {
        renderer.context.shouldRender = false
    }
}
