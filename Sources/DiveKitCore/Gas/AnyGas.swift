import Foundation

package struct AnyGas: Hashable, @unchecked Sendable {
    package let value: AnyHashable

    package var gas: (any GasRepresentable)? {
        value as? (any GasRepresentable)
    }

    package init(_ gas: some GasRepresentable) {
        value = AnyHashable(gas)
    }

    package static func == (lhs: AnyGas, rhs: AnyGas) -> Bool {
        lhs.value == rhs.value
    }

    package func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}
