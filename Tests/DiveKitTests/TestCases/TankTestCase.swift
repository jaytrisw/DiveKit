import XCTest
@testable import DiveKit

final class TankTestCase: SystemUnderTestCase<Tank> {

    func testInitializeWithUnblended() throws {
        // Given
        let fractionalPressure = 1.0
        let blend = Blend<Unblended>(.init(.oxygen, fractionalPressure: fractionalPressure))
        let volume: Volume = 40
        let pressure: Pressure = 3000
        let size = Tank.Size(volume: volume, ratedPressure: pressure, unit: .cubicFeet)

        // When
        XCTAssertNoThrow(try Tank(blend: blend, size: size))
    }

    func testInitializeWithUnblendedThrows() throws {
        // Given
        let fractionalPressure = 0.5
        let blend = Blend<Unblended>(.init(.oxygen, fractionalPressure: fractionalPressure))
        let volume: Volume = 40
        let pressure: Pressure = 3000
        let size = Tank.Size(volume: volume, ratedPressure: pressure, unit: .cubicFeet)

        // When
        try XCTAssertThrowsError(
            when: Tank(blend: blend, size: size),
            then: .input(.invalid(.blend(blend)), "Blend<Unblended>.blend()")) {
                XCTAssertEqual($0.localizationKey, "invalid.blend")
            }
    }

    func testFail() {
        XCTFail("Intentionally failing test")
    }
}
