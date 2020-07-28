import XCTest
@testable import DiveKit

final class EquivalentAirDepth: XCTestCase {
    
    lazy var enrichedAirCalculator = DKEnrichedAir.init()
    
    func test() throws {
        var gas = try Gas.enrichedAir(36)
        enrichedAirCalculator = DKEnrichedAir.init(waterType: .saltWater, measurementUnit: .imperial)
        var equivalentAirDepth = try enrichedAirCalculator.equivalentAirDepth(for: 90, with: gas)
        XCTAssertEqual(ceil(equivalentAirDepth.value), 67)
        equivalentAirDepth = try enrichedAirCalculator.equivalentAirDepth(for: 33, with: gas)
        XCTAssertEqual(ceil(equivalentAirDepth.round(to: 0)), 20)
        enrichedAirCalculator = DKEnrichedAir.init(waterType: .saltWater, measurementUnit: .metric)
        XCTAssertEqual(try enrichedAirCalculator.equivalentAirDepth(for: 27, with: gas).round(to: 2), 19.97)
        gas = try! Gas.enrichedAir(32)
        XCTAssertEqual(try enrichedAirCalculator.equivalentAirDepth(for: 35, with: gas).round(to: 1), 28.7)
        XCTAssertEqual(try enrichedAirCalculator.equivalentAirDepth(for: 30.5, with: gas).round(to: 1), 24.9)
        gas = Gas.air
        XCTAssertEqual(try enrichedAirCalculator.equivalentAirDepth(for: 35, with: gas).round(to: 0), 35)
        enrichedAirCalculator = DKEnrichedAir.init(waterType: .saltWater, measurementUnit: .imperial)
        gas = try! Gas.enrichedAir(32)
        XCTAssertEqual(try enrichedAirCalculator.equivalentAirDepth(for: 100, with: gas).round(to: 1), 81.5)
        enrichedAirCalculator = DKEnrichedAir.init(waterType: .freshWater, measurementUnit: .metric)
        XCTAssertEqual(try enrichedAirCalculator.equivalentAirDepth(for: 30, with: gas).round(to: 1), 24.4)
        enrichedAirCalculator = DKEnrichedAir.init(waterType: .freshWater, measurementUnit: .imperial)
        equivalentAirDepth = try enrichedAirCalculator.equivalentAirDepth(for: 110, with: gas)
        XCTAssertEqual(ceil(equivalentAirDepth.value), 90)
    }
    func testErrors() throws {
    }
}
