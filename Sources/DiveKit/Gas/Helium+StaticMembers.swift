import Foundation
@_spi(Experimental) import DiveKitCore

@_spi(Experimental)
public extension GasRepresentable where Self == Helium {
    /// A convenience helium gas value.
    ///
    /// - Since: 1.0.0
    static var helium: Self {
        .init()
    }
}
