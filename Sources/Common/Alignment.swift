public enum Alignment: Sendable {
    case topLeading, top, topTrailing
    case leading, center, trailing
    case bottomLeading, bottom, bottomTrailing
}
public struct HorizontalAlignment: Sendable, Equatable {
    let alignment: Alignment
    public static let leading: HorizontalAlignment = .init(alignment: .leading)
    public static let center: HorizontalAlignment = .init(alignment: .center)
    public static let trailing: HorizontalAlignment = .init(alignment: .trailing)
}
public struct VerticalAlignment: Sendable, Equatable {
    let alignment: Alignment
    public static let top: VerticalAlignment = .init(alignment: .top)
    public static let center: VerticalAlignment = .init(alignment: .center)
    public static let bottom: VerticalAlignment = .init(alignment: .bottom)
}
