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

    public var projectedValue: Binding<Value> {
        return Binding(get: { wrappedValue }, set: { (newValue) in wrappedValue = newValue })
    }

    // We can update this value internally
    let stateReference = StateReference()
}

class StateReference {
    var stateIdentifier: StateIdentifier?
    weak var stateManager: StateManager?
}

@propertyWrapper
public struct Binding<Value> {
    private let getFromState: () -> Value
    private let setToState: (Value) -> Void

    public init(_ bindingValue: Binding<Value>) {
        getFromState = bindingValue.getFromState
        setToState = bindingValue.setToState
    }

    public init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
        getFromState = get
        setToState = set
    }

    public var wrappedValue: Value {
        get { getFromState() }
        nonmutating set { setToState(newValue) }
    }
}
