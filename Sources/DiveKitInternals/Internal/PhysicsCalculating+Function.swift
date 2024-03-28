import DiveKitCore

package extension PhysicsCalculating {
    func gaugePressure(at depth: Double, orThrow error: (Double) -> Error<Double>) throws -> Calculation<Double, Units.Pressure> {
        try depth.validate(.nonNegative, orThrow: {
            error(depth)
        })
        .map { $0 / configuration.water.pressure(configuration.units).increase.value }
        .map { .init(value: $0, unit: .atmospheres, configuration: configuration) }
    }

    func atmospheresAbsolute(at depth: Double, orThrow error: (Double) -> Error<Double>) throws -> Calculation<Double, Units.Pressure> {
        try gaugePressure(at: depth, orThrow: error)
            .map { .init(value: $0.value + 1, unit: $0.unit, configuration: $0.configuration) }
    }
}
