import Foundation

package extension BuoyancyCalculating {
    func buoyancy(of object: Object, orThrow error: (Object) -> Error<Object>) throws -> Calculation<Buoyancy> {
        try object.validate(
            using: .nonNegative,
            orThrow: {
                error($0)
            })
        .map {
            $0.volume.value * configuration.water.weight(configuration.units).value
        }
        .map {
            $0 - object.weight.value
        }
        .map {
            .buoyancy($0, configuration: configuration)
        }
    }
}
