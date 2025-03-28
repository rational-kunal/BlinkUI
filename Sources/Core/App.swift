public protocol App {
    associatedtype Body: View
    @ViewBuilder var body: Self.Body { get }
}
