import DiveKitCore

package func error<C: ConfigurationProviding, Value>(
    describing calculator: C,
    for value: Value,
    with message: Error<Value>.Message,
    function: StaticString = #function) -> Error<Value> {
        .init(calculator: .init(describing: calculator), value: value, message: message, function: function)
    }
