public protocol App: View {
    @ViewBuilder var body: Self.Body { get }

    func userWillExit()
}

extension App {
    public func userWillExit() {
        // Default implementation does nothing
    }
}
