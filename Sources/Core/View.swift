public protocol View {
    associatedtype Body: View = Never
    @ViewBuilder var body: Self.Body { get }
}

extension View where Body == Never {
    public var body: Body { fatalError() }
}

extension Never: View {}
