import XCTest
@testable import DiveKit

final class RespiratoryMinuteVolume: XCTestCase {
    func test() throws {
        let diveKit = DiveKit.default
        let gasCalculator = DKGasCalculator(with: diveKit)
        let surfaceAirConsumption = try gasCalculator.surfaceAirConsumption(at: 66, for: 10, consuming: 900)
        let tank = DKTank(ratedPressure: 3000, volume: 80, type: .aluminumStandard)
        let respiratoryMinuteVolume = try gasCalculator.respiratoryMinuteVolume(for: surfaceAirConsumption, with: tank)
        XCTAssertEqual(respiratoryMinuteVolume, 0.8)
    }
    func testErrors() throws {
        
    }
}
