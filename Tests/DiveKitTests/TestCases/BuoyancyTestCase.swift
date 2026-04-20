import Testing
@testable import DiveKit

@Suite("Buoyancy", .tags(.buoyancy))
struct BuoyancyTestCase {
    @Test(arguments: [
        (value: 0.0, expected: Buoyancy.neutral),
        (42, .positive(42)),
        (-42, .negative(42))
    ])
    func initialization(value: Double, expected: Buoyancy) {
        let sut = Buoyancy(value)

        #expect(sut == expected)
    }
}
