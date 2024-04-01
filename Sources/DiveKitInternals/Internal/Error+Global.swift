import DiveKitCore

package func error<C: ConfigurationProviding, Value>(
    describing calculator: C,
    for value: Value,
    with message: Error<Value>.Message,
    function: StaticString = #function) -> Error<Value> {
        .init(value: value, message: message, object: .init(describing: calculator), function: function)
    }
