import Foundation

public struct Error<Value> {
    public let value: Value
    public let message: Message
    public var callSite: String

    package init(value: Value, message: Message, callSite: String) {
        self.value = value
        self.message = message
        self.callSite = callSite
    }

    package init(value: Value, message: Message, object: String, function: StaticString) {
        self.init(
            value: value,
            message: message,
            callSite: [
                object.components(separatedBy: ".").last ?? object,
                function.description.components(separatedBy: ".").last ?? function.description
            ]
                .joined(separator: "."))
    }
}

extension Error: Swift.Error {}
extension Error: Equatable where Value: Equatable {}
