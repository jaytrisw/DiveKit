import Foundation

public struct Error<Value> {
    public let value: Value
    public let message: Message
    public var callSite: String

    package init(calculator: String, value: Value, message: Message, function: StaticString) {
        self.value = value
        self.message = message
        callSite = [
            calculator.components(separatedBy: ".").last ?? calculator,
            function.description.components(separatedBy: ".").last ?? function.description
        ]
            .joined(separator: ".")
    }
}

extension Error: Swift.Error {}
extension Error: Equatable where Value: Equatable {}
