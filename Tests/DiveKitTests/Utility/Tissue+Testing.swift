@_spi(Experimental) import DiveKit

/// A gas DiveKit does not ship, used to exercise arbitrary-gas tracking.
struct Neon: GasRepresentable {
    var metabolism: Metabolism { .inert }
}

extension Tissue.Compartment.Loaded {
    /// The compartment when every inspired gas was tracked, otherwise `nil`.
    var tracked: Tissue.Compartment? {
        guard case let .tracked(compartment) = self else { return nil }
        return compartment
    }

    /// The compartment and ignored gases when some inspired gases were untracked, otherwise `nil`.
    var untracked: (compartment: Tissue.Compartment, gases: [any GasRepresentable])? {
        guard case let .untracked(compartment, gases) = self else { return nil }
        return (compartment, gases)
    }
}

extension Tissue.Compartment {
    /// The current tension of a tracked gas, or `nil` if the gas is untracked.
    func tension<Gas: GasRepresentable>(of gas: Gas) -> Double? {
        guard case let .tracked(_, tension) = tracking(of: gas) else { return nil }
        return tension.value
    }
}
