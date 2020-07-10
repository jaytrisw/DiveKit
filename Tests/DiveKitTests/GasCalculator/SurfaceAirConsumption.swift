import XCTest
@testable import DiveKit

final class SurfaceAirConsumption: XCTestCase {
    func test() throws {
        let diveKit = DiveKit.default
        let gasCalculator = DKGasCalculator(with: diveKit)
        let surfaceAirConsumption = try gasCalculator.surfaceAirConsumption(at: 90, for: 10, startGas: 3000, endGas: 2400)
        XCTAssertEqual(surfaceAirConsumption.round(to: 1), 16.1)
    }
    func testErrors() throws {
        
    }
}
