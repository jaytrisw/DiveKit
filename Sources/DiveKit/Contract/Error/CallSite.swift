import Foundation

public struct CallSite: CustomStringConvertible {
    public let description: String

    package init(description: String) {
        self.description = description
    }
}

extension CallSite: Equatable {}

package extension CallSite {
    init(object: String, function: StaticString) {
        description = [
            object.components(separatedBy: ".").last,
            function.description.components(separatedBy: ".").last
        ]
            .compactMap { $0 }
            .joined(separator: ".")
    }

    static func from<O>(_ object: O, function: StaticString = #function) -> Self {
        self.init(object: .init(describing: object), function: function)
    }
}
