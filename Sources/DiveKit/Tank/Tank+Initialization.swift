import Foundation
import DiveKitCore
import DiveKitInternal

public extension Tank {
    /// Creates a tank from an unblended gas mixture and a tank size.
    ///
    /// This initializer validates and converts the provided unblended gas mixture
    /// into a blended state before creating the tank.
    ///
    /// - Parameters:
    ///   - blend: The unblended gas mixture to store in the tank.
    ///   - size: The physical size specification of the tank.
    /// - Throws: `Error.blend` if `blend` cannot be converted into a
    ///   valid blended state.
    ///
    /// ```swift
    /// let tank = try Tank(
    ///     blend: unblendedBlend,
    ///     size: size
    /// )
    /// ```
    ///
    /// - Note: This initializer derives a `CallSite` automatically using `Tank`
    ///   as the originating object and the current function name.
    /// - Since: 1.0.0
    init(blend: Blend<Unblended>, size: Size) throws(Error) {
        let callSite = CallSite(object: .init(describing: Self.self), function: #function)
        self = .init(blend: try blend.blend(callSite), size: size)
    }
}
