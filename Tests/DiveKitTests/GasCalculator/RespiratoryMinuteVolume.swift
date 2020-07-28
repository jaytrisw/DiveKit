import XCTest
@testable import DiveKit

final class RespiratoryMinuteVolume: XCTestCase {
    func test() throws {
        let diveKit = DiveKit.default
        let gasCalculator = DKGasCalculator(with: diveKit)
        let surfaceAirConsumption = try gasCalculator.surfaceAirConsumption(at: 66, for: 10, consuming: 900)
        let tank = DKTank(ratedPressure: 3000, volume: 80, type: .aluminumStandard)
        let respiratoryMinuteVolume = try gasCalculator.respiratoryMinuteVolume(for: surfaceAirConsumption, with: tank)
        XCTAssertEqual(respiratoryMinuteVolume.round(to: 1), 0.8)
        let respiratoryMinuteVolume2 = try gasCalculator.respiratoryMinuteVolume(at: 66, for: 10, with: tank, consuming: 900)
        XCTAssertEqual(respiratoryMinuteVolume2.round(to: 1), respiratoryMinuteVolume.round(to: 1))
    }
    func testErrors() throws {
        
    }
}
