import Foundation
import DiveKitCore

package extension BuoyancyCalculating {
    func buoyancy(
        of object: Object,
        with configuration: Configuration,
        _ callSite: CallSite) throws(Error) -> Calculation<Buoyancy> {
            try object.weight.validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                .map { (_: Mass) throws(Error) in
                    try object.volume.validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                }
                .map { object.volume.value * configuration.water.weight(configuration.units).value }
                .map { $0 - object.weight.value }
                .map { .buoyancy($0, configuration: configuration) }
        }
}
