import XCTest
@testable import DiveKit

final class TankTestCase: SystemUnderTestCase<Tank> {

    func testInitializeWithUnblended() throws {
        // Given
        let pressure = 1.0
        let blend = Blend<Unblended>(.init(.oxygen, value: pressure))
        let size = Tank.Size(volume: 40, ratedPressure: 3000, unit: .cubicFeet)

        // Then
        XCTAssertNoThrow(try Tank(blend: blend, size: size))
    }

    func testInitializeWithUnblendedThrows() throws {
        // Given
        let pressure = 0.5
        let blend = Blend<Unblended>(.init(.oxygen, value: pressure))
        let size = Tank.Size(volume: 40, ratedPressure: 3000, unit: .cubicFeet)

        // When
        XCTAssertThrowsError(try Tank(blend: blend, size: size), as: Error<Double>.self) { error in
            // Then
            XCTAssertEqual(error.value, pressure)
            XCTAssertEqual(error.message.key, "dive.kit.blend.total.pressure")
            XCTAssertEqual(error.callSite, "Blend<Unblended>.blend()")
        }
    }
}
