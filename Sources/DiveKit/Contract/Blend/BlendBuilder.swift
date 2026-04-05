import Foundation

@resultBuilder
enum BlendBuilder {
    static func buildBlock<each Gas: GasRepresentable, State: BlendState>(_ components: repeat FractionalPressure<each Gas>) -> Blend<State> {
        .init(repeat ((each components).gas, (each components).fractionalPressure))
    }
}

package extension Blend where State == Blended {
    init(@BlendBuilder builder: () -> Self) {
        self = builder()
    }
}

package extension Blend where State == Unblended {
    init(@BlendBuilder builder: () -> Self) {
        self = builder()
    }
}

public extension Blend where State == Blended {
    init(@BlendBuilder builder: () throws(DiveKit.Error) -> Self) throws(DiveKit.Error) {
        self = try builder()
    }
}

public extension Blend where State == Unblended {
    init(@BlendBuilder builder: () throws(DiveKit.Error) -> Self) throws(DiveKit.Error) {
        self = try builder()
    }
}
