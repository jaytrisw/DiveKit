import Testing
@testable import DiveKit

@Suite("Tank", .tags(.tank))
struct TankTestCase {

    @Test
    func initializeWithUnblended() throws {
        let fractionalPressure = 1.0
        let blend = try Blend<Unblended>(.init(of: .oxygen, fractionalPressure: fractionalPressure))
        let volume: Volume = 40
        let pressure: Pressure = 3000
        let size = Tank.Size(volume: volume, ratedPressure: pressure, unit: .cubicFeet)

        _ = try Tank(blend: blend, size: size)
    }

    @Test
    func initializeWithUnblendedThrows() throws {
        let fractionalPressure = 0.5
        let blend = try Blend<Unblended>(.init(of: .oxygen, fractionalPressure: fractionalPressure))
        let volume: Volume = 40
        let pressure: Pressure = 3000
        let size = Tank.Size(volume: volume, ratedPressure: pressure, unit: .cubicFeet)
        let expectedError = Error.blend(.totalPressure(fractionalPressure, blend), "Tank.init(blend:size:)")

        try expectThrowsError(
            when: Tank(blend: blend, size: size),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.blend.total.pressure")
            }
    }
}
