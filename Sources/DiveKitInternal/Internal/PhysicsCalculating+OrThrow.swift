import Foundation
import DiveKitCore

package extension PhysicsCalculating {
    func gaugePressure(
        at depth: Depth,
        with configuration: Configuration,
        _ callSite: CallSite) throws(Error) -> Calculation<DecimalResult<Pressure>> {
            try depth.validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                .map { $0.value / configuration.water.pressure(configuration.units).increase.value }
                .map { .decimal($0, unit: .atmospheres, configuration: configuration) }
        }
    
    func atmospheresAbsolute(
        at depth: Depth,
        with configuration: Configuration,
        _ callSite: CallSite) throws(Error) -> Calculation<DecimalResult<Pressure>> {
            try gaugePressure(at: depth, with: configuration, callSite)
                .map { .decimal($0.result.value + 1, unit: $0.result.unit, configuration: $0.configuration) }
        }
}
