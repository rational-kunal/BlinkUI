public protocol EnvironmentKey {
    associatedtype Value
    static var defaultValue: Value { get }
}

// TODO: CoW ??
public struct EnvironmentValues {
    var values: [ObjectIdentifier: Any] = [:]
    public subscript<K: EnvironmentKey>(key: K.Type) -> K.Value {
        get { values[ObjectIdentifier(key)] as? K.Value ?? K.defaultValue }
        set { values[ObjectIdentifier(key)] = newValue }
    }
}

protocol AnyEnvironment {
    var environmentReference: EnvironmentReference { get }
}

@propertyWrapper
public struct Environment<Value>: AnyEnvironment {
    let keyPath: KeyPath<EnvironmentValues, Value>

    public init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
        self.keyPath = keyPath
    }

    public var wrappedValue: Value {
        guard
            let environmentValues = environmentReference.environmentProvider?.getEnvironmentValues()
        else {
            assertionFailure("Unable to get environment values")
            return EnvironmentValues()[keyPath: keyPath]
        }

        return environmentValues[keyPath: keyPath]
    }

    // We can update this value internally
    let environmentReference: EnvironmentReference = EnvironmentReference()
}

class EnvironmentReference {
    weak var environmentProvider: EnvironmentProvidable?
}
