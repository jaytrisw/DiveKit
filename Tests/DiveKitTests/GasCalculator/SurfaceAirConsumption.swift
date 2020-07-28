import XCTest
@testable import DiveKit

final class SurfaceAirConsumption: XCTestCase {
    
    let diveKit = DiveKit.default
    lazy var gasCalculator = DKGasCalculator(with: diveKit)
    
    
    func test() throws {
        
        let surfaceAirConsumption = try gasCalculator.surfaceAirConsumption(at: 90, for: 10, consuming: 600)
        let surfaceAirConsumption2 = try gasCalculator.surfaceAirConsumption(at: 90, for: 10, startGas: 3000, endGas: 2400)
        XCTAssertEqual(surfaceAirConsumption.round(to: 1), 16.1)
        XCTAssertEqual(surfaceAirConsumption2.round(to: 1), 16.1)
    }
    func testErrors() throws {
        XCTAssertThrowsError(try gasCalculator.surfaceAirConsumption(at: -90, for: 10, consuming: 600))
        XCTAssertThrowsError(try gasCalculator.surfaceAirConsumption(at: 90, for: -10, consuming: 600))
        XCTAssertThrowsError(try gasCalculator.surfaceAirConsumption(at: 90, for: 10, consuming: -600))
        XCTAssertThrowsError(try gasCalculator.surfaceAirConsumption(at: -90, for: 10, startGas: 3000, endGas: 2400))
        XCTAssertThrowsError(try gasCalculator.surfaceAirConsumption(at: 90, for: -10, startGas: 3000, endGas: 2400))
        XCTAssertThrowsError(try gasCalculator.surfaceAirConsumption(at: 90, for: 10, startGas: -3000, endGas: 2400))
        XCTAssertThrowsError(try gasCalculator.surfaceAirConsumption(at: 90, for: 10, startGas: 3000, endGas: -2400))
    }
}
