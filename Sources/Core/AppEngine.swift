import os

class AppEngine {
    let renderer: RenderEngine

    init(app: any App) {
        renderer = RenderEngine(rootView: app.body)
    }

    func run() {
        while true {
            renderer.updateAndRender()

            // TODO: Not good idea
            usleep(100_000)  // Sleep for 100ms
        }
    }
}
