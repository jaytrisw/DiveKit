import Foundation

package extension PhysicsCalculating {
    func gaugePressure(
        at depth: Depth,
        orThrow error: (Depth) -> Error<Depth>) throws -> Calculation<Double.Result<Pressure.Unit>> {
            try depth.validate(
                using: .nonNegative,
                orThrow: { error($0) })
            .map { $0.value / configuration.water.pressure(configuration.units).increase.value }
            .map { .double($0, unit: .atmospheres, configuration: configuration) }
        }
    
    func atmospheresAbsolute(
        at depth: Depth,
        orThrow error: (Depth) -> Error<Depth>) throws -> Calculation<Double.Result<Pressure.Unit>> {
            try gaugePressure(
                at: depth,
                orThrow: error)
            .map { .double($0.result.value + 1, unit: $0.result.unit, configuration: $0.configuration) }
        }
}
