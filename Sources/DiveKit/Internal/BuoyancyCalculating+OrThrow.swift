import Foundation

internal extension BuoyancyCalculating {
    func buoyancy(of object: Object, _ callSite: CallSite) throws -> Calculation<Buoyancy> {
        try object.weight.validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
            .map { try object.volume.validate(using: .nonNegative, orThrow: { .negative($0, callSite) }) }
            .map { object.volume.value * configuration.water.weight(configuration.units).value }
            .map { $0 - object.weight.value }
            .map { .buoyancy($0, configuration: configuration) }
    }
}
