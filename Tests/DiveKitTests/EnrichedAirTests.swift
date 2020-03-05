//import XCTest
//@testable import DiveKit
//
//final class EnrichedAirTests: XCTestCase {
//    var enrichedAir = DKEnrichedAir.init()
//    
//    func testMaximumOperatingDepthMinimumSaltwater() throws {
//        let imperialValues: [(Double, Double, Double)] = [(oxygenPercentage: 21, fractionOxygen: 1.4, chartDepth: 187), (22, 1.4, 177), (23, 1.4, 168), (24, 1.4, 160), (25, 1.4, 152), (26, 1.4, 145), (27, 1.4, 138), (28, 1.4, 132), (29, 1.4, 126), (30, 1.4, 121), (31, 1.4, 116), (32, 1.4, 111), (33, 1.4, 107), (34, 1.4, 103), (35, 1.4, 99), (36, 1.4, 95), (37, 1.4, 92), (38, 1.4, 89), (39, 1.4, 85), (40, 1.4, 82), (41, 1.4, 80), (42, 1.4, 77), (43, 1.4, 74), (44, 1.4, 72), (45, 1.4, 70), (46, 1.4, 67), (47, 1.4, 65), (48, 1.4, 63), (49, 1.4, 61), (50, 1.4, 59), (51, 1.4, 58), (52, 1.4, 56), (53, 1.4, 54), (54, 1.4, 53), (55, 1.4, 51), (56, 1.4, 49), (57, 1.4, 48), (58, 1.4, 47), (59, 1.4, 45), (21, 1.6, 218), (22, 1.6, 207), (23, 1.6, 197), (24, 1.6, 187), (25, 1.6, 178), (26, 1.6, 170), (27, 1.6, 163), (28, 1.6, 156), (29, 1.6, 149), (30, 1.6, 143), (31, 1.6, 137), (32, 1.6, 132), (33, 1.6, 127), (34, 1.6, 122), (35, 1.6, 118), (36, 1.6, 114), (37, 1.6, 110), (38, 1.6, 106), (39, 1.6, 102), (40, 1.6, 99), (41, 1.6, 96), (42, 1.6, 93), (43, 1.6, 90), (44, 1.6, 87), (45, 1.6, 84), (46, 1.6, 82), (47, 1.6, 79), (48, 1.6, 77), (49, 1.6, 75), (50, 1.6, 73), (51, 1.6, 71), (52, 1.6, 69), (53, 1.6, 67), (54, 1.6, 65), (55, 1.6, 63), (56, 1.6, 61), (57, 1.6, 60), (58, 1.6, 58), (59, 1.6, 56)]
//        try imperialValues.forEach { (percentage, fractionOxygen, maxOp) in
//            let gas = try Gas.enrichedAir(percentage)
//            let mod = try enrichedAir.maximumOperatingDepth(fractionOxygen: fractionOxygen, gas: gas)
//            XCTAssertEqual(mod, maxOp)
//        }
//        let metricValues: [(Double, Double, Double)] = [
//            (oxygenPercentage: 21, fractionOxygen: 1.4, chartDepth: 56.7), (21, 1.6, 66.2), (32, 1.4, 33.8), (32, 1.5, 36.9), (60, 1.4, 13.3), (60, 1.5, 15), (40, 1.4, 25.0), (40, 1.5, 27.5), (40, 1.6, 30)]
//        enrichedAir = DKEnrichedAir.init(waterType: .saltWater, measurementUnit: .metric)
//        try metricValues.forEach { (percentage, fractionOxygen, maxOp) in
//            let gas = try Gas.enrichedAir(percentage)
//            let mod = try enrichedAir.maximumOperatingDepth(fractionOxygen: fractionOxygen, gas: gas)
//            XCTAssertEqual(mod, maxOp)
//        }
//    }
//    func testThrows() throws {
//        var gas = Gas.air
//        XCTAssertThrowsError(try Gas.enrichedAir(-20))
//        XCTAssertThrowsError(try enrichedAir.bestBlend(for: 25, fractionOxygen: -1.4))
//        XCTAssertThrowsError(try enrichedAir.bestBlend(for: -25, fractionOxygen: 1.4))
//        XCTAssertThrowsError(try enrichedAir.bestBlendFor(depth: 25, fractionOxygen: -1.4))
//        XCTAssertThrowsError(try enrichedAir.bestBlendFor(depth: -25, fractionOxygen: 1.4))
//        XCTAssertThrowsError(try enrichedAir.maximumOperatingDepth(fractionOxygen: -2, gas: gas))
//        XCTAssertThrowsError(try enrichedAir.equivalentAirDepth(depth: -2, gas: gas))        
//        XCTAssertThrowsError(try enrichedAir.exceedsMaximumOperatingDepth(with: gas, fractionOxygen: -2, depth: 2))
//        XCTAssertThrowsError(try enrichedAir.exceedsMaximumOperatingDepth(with: gas, fractionOxygen: 2, depth: -2))
//        gas = try .enrichedAir(32)
//        XCTAssertTrue(try enrichedAir.exceedsMaximumOperatingDepth(with: gas, fractionOxygen: 1.4, depth: 132))
//        XCTAssertFalse(try enrichedAir.exceedsMaximumOperatingDepth(with: gas, fractionOxygen: 1.4, depth: 111))
//    }
//    func testEnrichedAirInititalizers() {
//        enrichedAir = DKEnrichedAir.init()
//        XCTAssertEqual(enrichedAir.diveKit.measurementUnit, DiveKit.MeasurementUnit.imperial)
//        XCTAssertEqual(enrichedAir.diveKit.waterType, DiveKit.WaterType.saltWater)
//        let diveKit = DiveKit.init()
//        enrichedAir = DKEnrichedAir.init(with: diveKit)
//        XCTAssertEqual(enrichedAir.diveKit.measurementUnit, DiveKit.MeasurementUnit.imperial)
//        XCTAssertEqual(enrichedAir.diveKit.waterType, DiveKit.WaterType.saltWater)
//        enrichedAir = DKEnrichedAir.init(measurementUnit: .metric)
//        XCTAssertEqual(enrichedAir.diveKit.measurementUnit, DiveKit.MeasurementUnit.metric)
//        XCTAssertEqual(enrichedAir.diveKit.waterType, DiveKit.WaterType.saltWater)
//        enrichedAir = DKEnrichedAir.init(waterType: .freshWater)
//        XCTAssertEqual(enrichedAir.diveKit.measurementUnit, DiveKit.MeasurementUnit.imperial)
//        XCTAssertEqual(enrichedAir.diveKit.waterType, DiveKit.WaterType.freshWater)
//        enrichedAir = DKEnrichedAir.init(waterType: .freshWater, measurementUnit: .metric)
//        XCTAssertEqual(enrichedAir.diveKit.measurementUnit, DiveKit.MeasurementUnit.metric)
//        XCTAssertEqual(enrichedAir.diveKit.waterType, DiveKit.WaterType.freshWater)
//    }
//    // MARK: - Equivalent Air Depth
//    func testEquivalentAirDepth() throws {
//        let imperialValues: [(Double, Double, Double)] = [(oxygenPercentage: 23, depth: 43, trustedResult: 42),
//        (32, 32, 27)]
//        enrichedAir = DKEnrichedAir.init(waterType: .saltWater, measurementUnit: .metric)
//        try imperialValues.forEach { (oxygenPercentage, depth, trustedResult) in
//            let gas = try Gas.enrichedAir(oxygenPercentage)
//            let ead = try enrichedAir.equivalentAirDepth(depth: depth, gas: gas)
//            XCTAssertEqual(ead, trustedResult)
//        }
//    }
//    func equivalentAirDepth() throws {
//        var gas = try! Gas.enrichedAir(36)
//        enrichedAir = DKEnrichedAir.init(waterType: .saltWater, measurementUnit: .imperial)
//        XCTAssertEqual(try! enrichedAir.equivalentAirDepth(depth: 90, gas: gas), 67)
//        XCTAssertEqual(try! enrichedAir.equivalentAirDepth(depth: 33, gas: gas), 20)
//        enrichedAir = DKEnrichedAir.init(waterType: .saltWater, measurementUnit: .metric)
//        XCTAssertEqual(try! enrichedAir.equivalentAirDepth(depth: 27, gas: gas, decimalPlaces: 2), 19.97)
//        gas = try! Gas.enrichedAir(32)
//        XCTAssertEqual(try! enrichedAir.equivalentAirDepth(depth: 35, gas: gas, decimalPlaces: 1), 28.7)
//        XCTAssertEqual(try! enrichedAir.equivalentAirDepth(depth: 30.5, gas: gas, decimalPlaces: 1), 24.9)
//        gas = Gas.air
//        XCTAssertEqual(try! enrichedAir.equivalentAirDepth(depth: 35, gas: gas, decimalPlaces: 1), 35)
//        enrichedAir = DKEnrichedAir.init(waterType: .saltWater, measurementUnit: .imperial)
//        gas = try! Gas.enrichedAir(32)
//        XCTAssertEqual(try! enrichedAir.equivalentAirDepth(depth: 100, gas: gas, decimalPlaces: 1), 81.5)
//        enrichedAir = DKEnrichedAir.init(waterType: .freshWater, measurementUnit: .metric)
//        XCTAssertEqual(try! enrichedAir.equivalentAirDepth(depth: 30, gas: gas, decimalPlaces: 1), 24.4)
//        enrichedAir = DKEnrichedAir.init(waterType: .freshWater, measurementUnit: .imperial)
//        XCTAssertEqual(try! enrichedAir.equivalentAirDepth(depth: 110, gas: gas), 90)
//    }
//    
//    // MARK: - Best Blend
//    func testBestBlend() {
//        enrichedAir = DKEnrichedAir(waterType: .saltWater, measurementUnit: .metric)
//        XCTAssertEqual(try! enrichedAir.bestBlend(for: 35, fractionOxygen: 1.4).percentOxygen, 31)
//        XCTAssertEqual(try! enrichedAir.bestBlend(for: 25, fractionOxygen: 1.4).percentOxygen, 40)
//        XCTAssertEqual(try! enrichedAir.bestBlendFor(depth: 35, fractionOxygen: 1.4).percentOxygen, 31)
//        XCTAssertEqual(try! enrichedAir.bestBlendFor(depth: 25, fractionOxygen: 1.4).percentOxygen, 40)
//        enrichedAir = DKEnrichedAir(waterType: .saltWater, measurementUnit: .imperial)
//        XCTAssertEqual(try! enrichedAir.bestBlend(for: 100, fractionOxygen: 1.4).percentOxygen, 34)
//        XCTAssertEqual(try! enrichedAir.bestBlendFor(depth: 100, fractionOxygen: 1.4).percentOxygen, 34)
//    }
//}
