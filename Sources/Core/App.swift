public protocol App: View {
    @ViewBuilder var body: Self.Body { get }
}
