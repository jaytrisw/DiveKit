import XCTest
@testable import DiveKit

final class TestPartialPressure: XCTestCase {
    
    let diveKit = DiveKit.default
    lazy var gasCalculator = DKGasCalculator(with: diveKit)
    let gas = Gas.air
    
    func test() throws {
        let airPartialPressure = gas.partialPressure
        XCTAssertEqual(try gasCalculator.partialPressure(of: .air).fractionOxygen, airPartialPressure.fractionOxygen)
        XCTAssertEqual(try gasCalculator.partialPressure(of: .air).fractionNitrogen, airPartialPressure.fractionNitrogen)
        XCTAssertEqual(try gasCalculator.partialPressure(of: .air).fractionTraceGases, airPartialPressure.fractionTraceGases)
        XCTAssertThrowsError(try gasCalculator.partialPressure(of: gas, at: -20))
    }
    func testErrors() throws {
        XCTAssertThrowsError(try gasCalculator.partialPressure(of: gas, at: -20))
    }
}
