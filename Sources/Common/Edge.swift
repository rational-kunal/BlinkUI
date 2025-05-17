public enum Edge {
    case top
    case bottom
    case leading
    case trailing
}
public enum EdgeSet {
    case all
    case top
    case bottom
    case leading
    case trailing
    case horizontal
    case vertical

    var set: Set<Edge> {
        switch self {
        case .all:
            return [.top, .bottom, .leading, .trailing]
        case .top:
            return [.top]
        case .bottom:
            return [.bottom]
        case .leading:
            return [.leading]
        case .trailing:
            return [.trailing]
        case .horizontal:
            return [.leading, .trailing]
        case .vertical:
            return [.top, .bottom]
        }
    }

    func contains(_ edge: Edge) -> Bool {
        return set.contains(edge)
    }
}
