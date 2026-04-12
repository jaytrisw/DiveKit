import Foundation

@resultBuilder
public enum BlendBuilder {
    public static func buildBlock<each Gas: GasRepresentable, State: BlendState>(_ components: repeat FractionalPressure<each Gas>) -> Blend<State> {
        .init(repeat ((each components).gas, (each components).value))
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
    init(@BlendBuilder builder: () throws(Error) -> Self) throws(Error) {
        self = try builder()
    }
}

public extension Blend where State == Unblended {
    init(@BlendBuilder builder: () throws(Error) -> Self) throws(Error) {
        self = try builder()
    }
}
