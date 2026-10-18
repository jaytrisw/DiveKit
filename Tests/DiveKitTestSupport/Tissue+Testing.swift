@_spi(Experimental) import DiveKit

/// A gas DiveKit does not ship, used to exercise arbitrary gases.
package struct Neon: GasRepresentable {
    package init() {}

    package var metabolism: Metabolism { .inert }
    package var narcoticPotency: NarcoticPotency { .relative(0.3) }
}

extension Tissue.Compartment.Loaded {
    /// The compartment when every inspired gas was tracked, otherwise `nil`.
    package var tracked: Tissue.Compartment? {
        guard case let .tracked(compartment) = self else { return nil }
        return compartment
    }

    /// The compartment and ignored gases when some inspired gases were untracked, otherwise `nil`.
    package var untracked: (compartment: Tissue.Compartment, gases: [any GasRepresentable])? {
        guard case let .untracked(compartment, gases) = self else { return nil }
        return (compartment, gases)
    }
}

extension Tissue.Compartment {
    /// The current tension of a tracked gas, or `nil` if the gas is untracked.
    package func tension<Gas: GasRepresentable>(of gas: Gas) -> Double? {
        guard case let .tracked(_, tension) = tracking(of: gas) else { return nil }
        return tension.value
    }
}
