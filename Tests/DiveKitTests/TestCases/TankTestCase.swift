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

        // Then
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
        XCTAssertThrowsError(try Tank(blend: blend, size: size), as: Error<Double>.self) { error in
            // Then
            XCTAssertEqual(error.value, fractionalPressure)
            XCTAssertEqual(error.message.key, "dive.kit.blend.total.pressure")
            XCTAssertEqual(error.callSite, "Blend<Unblended>.blend()")
        }
    }
}
