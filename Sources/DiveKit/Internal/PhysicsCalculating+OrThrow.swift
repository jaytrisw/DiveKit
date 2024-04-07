import Foundation

package extension PhysicsCalculating {
    func gaugePressure(
        at depth: Depth,
        orThrow error: (Depth) -> Error<Depth>) throws -> Calculation<DecimalOutput<Pressure>> {
            try depth.validate(
                using: .nonNegative,
                orThrow: { error($0) })
            .map { $0.value / configuration.water.pressure(configuration.units).increase.value }
            .map { .decimal(.init($0), unit: .atmospheres, configuration: configuration) }
        }
    
    func atmospheresAbsolute(
        at depth: Depth,
        orThrow error: (Depth) -> Error<Depth>) throws -> Calculation<DecimalOutput<Pressure>> {
            try gaugePressure(
                at: depth,
                orThrow: error)
            .map { .decimal(.init($0.result.decimal.value + 1), unit: $0.result.unit, configuration: $0.configuration) }
        }
}
