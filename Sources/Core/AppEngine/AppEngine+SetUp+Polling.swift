import Foundation

extension AppEngine {
    func setUpPoll() {
        let targetFPS = config.framesPerSecond
        let frameDuration = 1.0 / targetFPS

        while true {
            let frameStart = DispatchTime.now().uptimeNanoseconds

            /**
             * This is where the main loop runs.
             * It will call the loop function which is responsible for rendering the screen.
             **/
            loop()

            let frameEnd = DispatchTime.now().uptimeNanoseconds
            let elapsed = Double(frameEnd - frameStart) / 1_000_000_000.0

            let sleepTime = frameDuration - elapsed
            if sleepTime > 0 {
                let nanoseconds = UInt64(sleepTime * 1_000_000_000)
                let deadline = DispatchTime.now() + .nanoseconds(Int(nanoseconds))
                let _ = DispatchSemaphore(value: 0).wait(timeout: deadline)
            }
        }
    }
}
