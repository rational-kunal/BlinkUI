protocol AnyState {
    var stateReference: StateReference { get }
}

@propertyWrapper
public struct State<Value>: AnyState {
    private let initialValue: Value

    public init(wrappedValue initialValue: Value) {
        self.initialValue = initialValue
    }

    public var wrappedValue: Value {
        get {
            guard let stateManager = stateReference.stateManager,
                let stateIdentifier = stateReference.stateIdentifier
            else {
                assertionFailure("Attempted to use @State before initialization")
                return initialValue
            }
            if let value = stateManager[stateIdentifier] as? Value {
                return value
            }
            return initialValue
        }
        nonmutating set {
            guard let stateManager = stateReference.stateManager,
                let stateIdentifier = stateReference.stateIdentifier
            else {
                assertionFailure("Attempted to use @State before initialization")
                return
            }

            stateManager[stateIdentifier] = newValue
        }
    }

    // We can update this value internally
    let stateReference = StateReference()
}

class StateReference {
    var stateIdentifier: StateIdentifier?
    weak var stateManager: StateManager?
}
