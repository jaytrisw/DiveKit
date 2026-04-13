import Foundation

/// Context describing where an error originated.
///
/// `CallSite` is stored with domain errors to preserve the object and function
/// that produced the failure.
///
/// - Since: 1.0.0
public struct CallSite: CustomStringConvertible, Sendable {
    /// A human-readable call-site description.
    ///
    /// - Since: 1.0.0
    public let description: String

    /// Creates a call site from a description.
    ///
    /// - Parameter description: A human-readable call-site description.
    /// - Since: 1.0.0
    package init(description: String) {
        self.description = description
    }
}

/// Allows call sites to be compared.
///
/// - Since: 1.0.0
extension CallSite: Equatable {}

package extension CallSite {
    /// Creates a call site from an object name and function.
    ///
    /// - Parameters:
    ///   - object: The object or type where the error originated.
    ///   - function: The function where the error originated.
    /// - Since: 1.0.0
    init(object: String, function: StaticString) {
        description = [
            object.components(separatedBy: ".").last,
            function.description.components(separatedBy: ".").last
        ]
            .compactMap { $0 }
            .joined(separator: ".")
    }

    /// Creates a call site from an object instance or type.
    ///
    /// - Parameters:
    ///   - object: The object or type where the error originated.
    ///   - function: The function where the error originated.
    /// - Returns: A call site for the provided object and function.
    /// - Since: 1.0.0
    static func from<O>(_ object: O, function: StaticString = #function) -> Self {
        self.init(object: .init(describing: object), function: function)
    }
}
