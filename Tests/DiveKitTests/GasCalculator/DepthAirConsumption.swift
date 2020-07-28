import XCTest
@testable import DiveKit

final class DepthAirConsumption: XCTestCase {
    
    let diveKit = DiveKit.default
    lazy var gasCalculator = DKGasCalculator(with: diveKit)
    
    func test() throws {
        let surfaceAirConsumption = try gasCalculator.surfaceAirConsumption(at: 66, for: 10, consuming: 900)
        let tank = DKTank(ratedPressure: 3000, volume: 80, type: .aluminumStandard)
        let respiratoryMinuteVolume = try gasCalculator.respiratoryMinuteVolume(for: surfaceAirConsumption, with: tank)
        XCTAssertEqual(respiratoryMinuteVolume.round(to: 1), 0.8)
    }
    func testErrors() throws {
        XCTAssertThrowsError(try gasCalculator.depthAirConsumption(for: -10, consuming: 200))
        XCTAssertThrowsError(try gasCalculator.depthAirConsumption(for: 10, consuming: -200))
    }
}
