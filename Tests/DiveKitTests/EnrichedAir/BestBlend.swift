import XCTest
@testable import DiveKit

final class BestBlend: XCTestCase {
    
    lazy var enrichedAirCalculator = DKEnrichedAir.init()
    
    func test() throws {
        XCTAssertEqual(try enrichedAirCalculator.bestBlend(for: 111, fractionOxygen: 1.4).percentOxygen, 32)
        XCTAssertEqual(try enrichedAirCalculator.bestBlend(for: 110, fractionOxygen: 1.4).percentOxygen, 32)
        XCTAssertEqual(try enrichedAirCalculator.bestBlend(for: 112, fractionOxygen: 1.4).percentOxygen, 31)
        XCTAssertEqual(try enrichedAirCalculator.bestBlend(for: 102, fractionOxygen: 1.4).percentOxygen, 34)
        XCTAssertEqual(try enrichedAirCalculator.bestBlend(for: 62, fractionOxygen: 1.4).percentOxygen, 48)
        XCTAssertEqual(try enrichedAirCalculator.bestBlend(for: 105, fractionOxygen: 1.4).percentOxygen, 33)
        XCTAssertEqual(try enrichedAirCalculator.bestBlend(for: 49, fractionOxygen: 1.4).percentOxygen, 56)
        enrichedAirCalculator = DKEnrichedAir.init(measurementUnit: .metric)
        XCTAssertEqual(try enrichedAirCalculator.bestBlend(for: 26, fractionOxygen: 1.4).percentOxygen, 38)
        XCTAssertEqual(try enrichedAirCalculator.bestBlend(for: 27, fractionOxygen: 1.4).percentOxygen, 37)
        XCTAssertEqual(try enrichedAirCalculator.bestBlend(for: 28, fractionOxygen: 1.4).percentOxygen, 36)
        XCTAssertEqual(try enrichedAirCalculator.bestBlend(for: 29, fractionOxygen: 1.4).percentOxygen, 35)
    }
    func textErrors() throws {
        XCTAssertThrowsError(try enrichedAirCalculator.bestBlend(for: 25, fractionOxygen: -1.4))
        XCTAssertThrowsError(try enrichedAirCalculator.bestBlend(for: -25, fractionOxygen: 1.4))
    }
}
