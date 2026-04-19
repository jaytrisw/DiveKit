import Testing
@testable import DiveKit

struct DepthQuantityTestCase {

    @Test(arguments: [
        (-100, "-100 feet"),
        (0, "0 feet"),
        (0.1, "0.1 feet"),
        (1, "1 foot"),
        (1.001, "1.001 feet"),
        (1.0006, "1.001 feet"),
        (10, "10 feet"),
        (100, "100 feet")
    ])
    func imperialFull(value: Double, output: String) {
        #expect(quantity(value, in: .feet, style: .full) == output)
    }

    @Test(arguments: [
        (-100, "-100 ft"),
        (0, "0 ft"),
        (0.1, "0.1 ft"),
        (1, "1 ft"),
        (1.001, "1.001 ft"),
        (1.0006, "1.001 ft"),
        (10, "10 ft"),
        (100, "100 ft")
    ])
    func imperialShort(value: Double, output: String) {
        #expect(quantity(value, in: .feet, style: .short) == output)
    }

    @Test(arguments: [
        (-100, "-100 meters"),
        (0, "0 meters"),
        (0.1, "0.1 meters"),
        (1, "1 meter"),
        (1.001, "1.001 meters"),
        (1.0006, "1.001 meters"),
        (10, "10 meters"),
        (100, "100 meters")
    ])
    func metricFull(value: Double, output: String) {
        #expect(quantity(value, in: .meters, style: .full) == output)
    }

    @Test(arguments: [
        (-100, "-100 m"),
        (0, "0 m"),
        (0.1, "0.1 m"),
        (1, "1 m"),
        (1.001, "1.001 m"),
        (1.0006, "1.001 m"),
        (10, "10 m"),
        (100, "100 m")
    ])
    func metricShort(value: Double, output: String) {
        #expect(quantity(value, in: .meters, style: .short) == output)
    }

    private func quantity(_ value: Double, in unit: Depth.Unit, style: LocalizationStyle) -> String {
        unit.localization(for: .quantity(value, style))
    }
}
