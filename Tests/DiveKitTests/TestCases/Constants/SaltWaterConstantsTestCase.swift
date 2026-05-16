import Testing
@testable import DiveKit

@Suite("Salt Water Constants", .tags(.constants, .saltWater))
struct SaltWaterConstantsTestCase {
    @Test(arguments: [
        (units: Units.imperial, value: 64.0, unit: Mass.Unit.pounds, volume: Volume.Unit.cubicFeet),
        (.metric, 1.03, .kilograms, .liters)
    ])
    func weightConstants(units: Units, value: Double, unit: Mass.Unit, volume: Volume.Unit) {
        let result = Water.salt.weight(units)

        #expect(result.value.isApproximately(value))
        #expect(result.unit == unit)
        #expect(result.volume == volume)
    }

    @Test(arguments: [
        (units: Units.imperial, value: 33.0, unit: Depth.Unit.feet),
        (.metric, 10, .meters)
    ])
    func pressureIncreaseConstants(units: Units, value: Double, unit: Depth.Unit) {
        let result = Water.salt.pressure(units)

        #expect(result.increase.value.isApproximately(value))
        #expect(result.increase.unit == unit)
    }
}
