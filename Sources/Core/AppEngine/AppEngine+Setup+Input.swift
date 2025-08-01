import Foundation

extension AppEngine {
    func setUpInput() {
        userInputSource.setEventHandler { [weak self] in
            guard let self else { return }
            var buffer = [UInt8](repeating: 0, count: 8)
            let bytesRead = read(STDIN_FILENO, &buffer, buffer.count)
            guard bytesRead > 0 else { return }
            for i in 0..<bytesRead {
                let key = buffer[i]
                if let keyString = String(bytes: [key], encoding: .utf8) {
                    onUserInput(keyString)  // Execute the userInputBlock with the raw string
                }
            }
        }
        userInputSource.resume()
    }
}
