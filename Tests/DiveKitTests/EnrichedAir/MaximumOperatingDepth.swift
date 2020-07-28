import XCTest
@testable import DiveKit

final class MaximumOperatingDepth: XCTestCase {
    
    lazy var enrichedAirCalculator = DKEnrichedAir.init()
    
    func test() throws {
        let imperialValues: [(Double, Double, Double)] = [(oxygenPercentage: 21, fractionOxygen: 1.4, chartDepth: 187), (22, 1.4, 177), (23, 1.4, 168), (24, 1.4, 160), (25, 1.4, 152), (26, 1.4, 145), (27, 1.4, 138), (28, 1.4, 132), (29, 1.4, 126), (30, 1.4, 121), (31, 1.4, 116), (32, 1.4, 111), (33, 1.4, 107), (34, 1.4, 103), (35, 1.4, 99), (36, 1.4, 95), (37, 1.4, 92), (38, 1.4, 89), (39, 1.4, 85), (40, 1.4, 82), (41, 1.4, 80), (42, 1.4, 77), (43, 1.4, 74), (44, 1.4, 72), (45, 1.4, 70), (46, 1.4, 67), (47, 1.4, 65), (48, 1.4, 63), (49, 1.4, 61), (50, 1.4, 59), (51, 1.4, 58), (52, 1.4, 56), (53, 1.4, 54), (54, 1.4, 53), (55, 1.4, 51), (56, 1.4, 49), (57, 1.4, 48), (58, 1.4, 47), (59, 1.4, 45), (21, 1.6, 218), (22, 1.6, 207), (23, 1.6, 197), (24, 1.6, 187), (25, 1.6, 178), (26, 1.6, 170), (27, 1.6, 163), (28, 1.6, 156), (29, 1.6, 149), (30, 1.6, 143), (31, 1.6, 137), (32, 1.6, 132), (33, 1.6, 127), (34, 1.6, 122), (35, 1.6, 118), (36, 1.6, 114), (37, 1.6, 110), (38, 1.6, 106), (39, 1.6, 102), (40, 1.6, 99), (41, 1.6, 96), (42, 1.6, 93), (43, 1.6, 90), (44, 1.6, 87), (45, 1.6, 84), (46, 1.6, 82), (47, 1.6, 79), (48, 1.6, 77), (49, 1.6, 75), (50, 1.6, 73), (51, 1.6, 71), (52, 1.6, 69), (53, 1.6, 67), (54, 1.6, 65), (55, 1.6, 63), (56, 1.6, 61), (57, 1.6, 60), (58, 1.6, 58), (59, 1.6, 56)]
        try imperialValues.forEach { (percentage, fractionOxygen, maximumOperatingDepthChart) in
            let gas = try Gas.enrichedAir(percentage)
            let maximumOperatingDepth = try enrichedAirCalculator.maximumOperatingDepth(fractionOxygen: fractionOxygen, gas: gas)
            XCTAssertEqual(maximumOperatingDepth.round(to: 0), maximumOperatingDepthChart)
        }
        let metricValues: [(Double, Double, Double)] = [
            (oxygenPercentage: 21, fractionOxygen: 1.4, chartDepth: 56.7), (21, 1.6, 66.2), (32, 1.4, 33.8), (32, 1.5, 36.9), (60, 1.4, 13.3), (60, 1.5, 15), (40, 1.4, 25.0), (40, 1.5, 27.5), (40, 1.6, 30)]
        enrichedAirCalculator = DKEnrichedAir.init(waterType: .saltWater, measurementUnit: .metric)
        try metricValues.forEach { (percentage, fractionOxygen, maximumOperatingDepthChart) in
            let gas = try Gas.enrichedAir(percentage)
            let maximumOperatingDepth = try enrichedAirCalculator.maximumOperatingDepth(fractionOxygen: fractionOxygen, gas: gas)
            XCTAssertEqual(maximumOperatingDepth.round(to: 1), maximumOperatingDepthChart)
        }
    }
    func testErrors() throws {
        XCTAssertThrowsError(try enrichedAirCalculator.maximumOperatingDepth(fractionOxygen: -10, gas: try Gas.enrichedAir(32)))
    }
}
