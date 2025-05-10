/// A simple view identifier that uniquely identifies a view using its hierarchical positions.
/// The `ViewIdentifier` remains consistent across render cycles, ensuring stable identification.
struct ViewIdentifier {
    var positions: [Int] = []

    func isDescendent(ofViewIdentifier: ViewIdentifier) -> Bool {
        guard positions.count >= ofViewIdentifier.positions.count else {
            return false
        }
        return ofViewIdentifier.positions
            == Array(positions.prefix(ofViewIdentifier.positions.count))
    }

    func withPosition(_ position: Int) -> ViewIdentifier {
        return ViewIdentifier(positions: positions + [position])
    }

    func withState(_ stateName: String) -> StateIdentifier {
        return StateIdentifier(viewIdentifier: self, stateIdentifier: stateName)
    }
}
extension ViewIdentifier: Hashable {}
extension ViewIdentifier: CustomStringConvertible {
    var description: String {
        return positions.map(String.init).joined(separator: ".")
    }
}

struct StateIdentifier {
    var viewIdentifier: ViewIdentifier
    var stateIdentifier: String
}
extension StateIdentifier: Hashable {}
extension StateIdentifier: CustomStringConvertible {
    var description: String {
        return "\(viewIdentifier)->\(stateIdentifier)"
    }
}
