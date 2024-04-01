import DiveKitCore

package extension PhysicsCalculating {
    func gaugePressure(
        at depth: Double,
        orThrow error: (Double) -> Error<Double>) throws -> Calculation<DoubleResult<Units.Pressure>> {
            try depth.validate(with: .nonNegative, orThrow: { error($0) })
                .map { $0 / configuration.water.pressure(configuration.units).increase.value }
                .map { .init(result: .init(value: $0, unit: .atmospheres), configuration: configuration) }
        }

    func atmospheresAbsolute(at depth: Double, orThrow error: (Double) -> Error<Double>) throws -> Calculation<DoubleResult<Units.Pressure>> {
        try gaugePressure(at: depth, orThrow: error)
            .map { .init(result: .init(value: $0.result.value + 1, unit: $0.result.unit), configuration: $0.configuration) }
    }
}
