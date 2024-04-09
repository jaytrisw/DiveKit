import Foundation

internal extension BuoyancyCalculating {
    func buoyancy(of object: Object, _ callSite: CallSite) throws -> Calculation<Buoyancy> {
        try object.validate(
            using: .nonNegative,
            orThrow: {
                Error.input(.invalid(.object($0)), callSite)
            })
        .map { $0.volume.value * configuration.water.weight(configuration.units).value }
        .map { $0 - object.weight.value }
        .map { .buoyancy($0, configuration: configuration) }
    }
}
