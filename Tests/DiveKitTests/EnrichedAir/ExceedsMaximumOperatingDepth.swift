import XCTest
@testable import DiveKit

final class ExceedsMaximumOperatingDepth: XCTestCase {
    
    lazy var enrichedAirCalculator = DKEnrichedAir.init()
    
    func test() throws {
        let gas = try Gas.enrichedAir(32)
        XCTAssertTrue(enrichedAirCalculator.exceedsMaximumOperatingDepth(with: gas, fractionOxygen: 1.4, depth: 112))
        XCTAssertFalse(enrichedAirCalculator.exceedsMaximumOperatingDepth(with: gas, fractionOxygen: 1.4, depth: 110))
    }
}
