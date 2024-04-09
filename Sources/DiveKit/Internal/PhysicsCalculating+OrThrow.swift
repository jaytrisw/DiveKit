import Foundation

internal extension PhysicsCalculating {
    func gaugePressure(
        at depth: Depth,
        _ callSite: CallSite) throws -> Calculation<DecimalResult<Pressure>> {
            try depth.validate(
                using: .nonNegative,
                orThrow: { Error.input(.negative(.depth($0)), callSite) })
            .map { $0.value / configuration.water.pressure(configuration.units).increase.value }
            .map { .decimal($0, unit: .atmospheres, configuration: configuration) }
        }
    
    func atmospheresAbsolute(
        at depth: Depth,
        _ callSite: CallSite) throws -> Calculation<DecimalResult<Pressure>> {
            try gaugePressure(at: depth, callSite)
                .map { .decimal($0.result.value + 1, unit: $0.result.unit, configuration: $0.configuration) }
        }
}
