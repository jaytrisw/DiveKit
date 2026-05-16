import Testing
@testable import DiveKit

@Suite("Fresh Water Constants", .tags(.constants, .freshWater))
struct FreshWaterConstantsTestCase {
    @Test(arguments: [
        (units: Units.imperial, value: 62.4, unit: Mass.Unit.pounds, volume: Volume.Unit.cubicFeet),
        (.metric, 1, .kilograms, .liters)
    ])
    func weightConstants(units: Units, value: Double, unit: Mass.Unit, volume: Volume.Unit) {
        let result = Water.fresh.weight(units)

        #expect(result.value.isApproximately(value))
        #expect(result.unit == unit)
        #expect(result.volume == volume)
    }

    @Test(arguments: [
        (units: Units.imperial, value: 34.0, unit: Depth.Unit.feet),
        (.metric, 10.3, .meters)
    ])
    func pressureIncreaseConstants(units: Units, value: Double, unit: Depth.Unit) {
        let result = Water.fresh.pressure(units)

        #expect(result.increase.value.isApproximately(value))
        #expect(result.increase.unit == unit)
    }
}
