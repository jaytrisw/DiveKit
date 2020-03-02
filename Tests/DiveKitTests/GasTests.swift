import XCTest
@testable import DiveKit

final class GasTests: XCTestCase {
    func testAir() {
        var air = Gas.air
        XCTAssertFalse(air.isContaminated)
        XCTAssertFalse(air.isEnrichedAir)
        XCTAssertEqual(air.percentHelium, 0.0)
        XCTAssertEqual(air.percentTraceGases, 0.1)
        XCTAssertEqual(air.percentContaminantGases, 0.0)
        XCTAssertEqual(air.percentOxygen, 20.9)
        XCTAssertEqual(air.percentNitrogen, 79.0)
        try! air.setDepth(33, diveKit: DiveKit.init())
        XCTAssertEqual(air.density, 2)
        XCTAssertEqual(air.pressure, 2)
        XCTAssertEqual(air.fractionVolume, 0.5)
        XCTAssertThrowsError(try air.setDepth(-33, diveKit: DiveKit.init()))
        let partialPressure = air.partialPressure
        XCTAssertEqual(partialPressure.fractionOxygen, 0.418)
        XCTAssertEqual(partialPressure.fractionNitrogen, 1.58)
        XCTAssertEqual(partialPressure.fractionHelium, 0)
        XCTAssertEqual(partialPressure.fractionContaminantGases, 0)
        XCTAssertEqual(partialPressure.fractionTraceGases, 0.002)
        
    }
    func testEnrichedAirThirtyTwo() {
        var enrichedAir = try! Gas.enrichedAir(32)
        XCTAssertFalse(enrichedAir.isContaminated)
        XCTAssertTrue(enrichedAir.isEnrichedAir)
        XCTAssertEqual(enrichedAir.percentHelium, 0.0)
        XCTAssertEqual(enrichedAir.percentTraceGases, 0.0)
        XCTAssertEqual(enrichedAir.percentContaminantGases, 0.0)
        XCTAssertEqual(enrichedAir.percentOxygen, 32.0)
        XCTAssertEqual(enrichedAir.percentNitrogen, 68.0)
        XCTAssertThrowsError(try enrichedAir.setContaminants(["Carbon Monoxide" : 100]))
        XCTAssertThrowsError(try Gas.enrichedAir(101))
        XCTAssertThrowsError(try Gas.enrichedAir(-101))
    }
    func testContaminantGas() {
        var gas = try! Gas.init(
            percentOxygen: 20.7,
            percentNitrogen: 79,
            percentTraceGases: 0.1,
            percentContaminantGases: 0.2)
        XCTAssertThrowsError(try gas.setContaminants(["Carbon Monoxide" : 0.4]))
        XCTAssertNoThrow(try gas.setContaminants(["Carbon Monoxide" : 0.2]))
        XCTAssertTrue(gas.isContaminated)
        let partialPressure = gas.partialPressure
        XCTAssertEqual(partialPressure.fractionOxygen, 0.207)
        XCTAssertEqual(partialPressure.fractionNitrogen, 0.79)
        XCTAssertEqual(partialPressure.fractionHelium, 0)
        XCTAssertEqual(partialPressure.fractionContaminantGases, 0.002)
        XCTAssertEqual(partialPressure.fractionTraceGases, 0.001)
        try! gas.setDepth(99, diveKit: DiveKit.init())
        XCTAssertEqual(gas.pressure, 4)
        XCTAssertEqual(gas.effectivePercentage(gas.percentContaminantGases), 0.8)
    }
    func testThrowingInitializers() {
        XCTAssertThrowsError(try Gas.init(percentOxygen: 10, percentNitrogen: 10))
        XCTAssertThrowsError(try Gas.init(percentOxygen: 80, percentNitrogen: 80))
        XCTAssertThrowsError(try Gas.init(percentOxygen: -10, percentNitrogen: 80))
        XCTAssertThrowsError(try Gas.init(percentOxygen: 80, percentNitrogen: -80))
        XCTAssertThrowsError(try Gas.init(percentOxygen: -10, percentNitrogen: 10, percentTraceGases: 10))
        XCTAssertThrowsError(try Gas.init(percentOxygen: 10, percentNitrogen: -10, percentTraceGases: 10))
        XCTAssertThrowsError(try Gas.init(percentOxygen: 10, percentNitrogen: 10, percentTraceGases: -10))
        XCTAssertThrowsError(try Gas.init(percentOxygen: 10, percentNitrogen: 10, percentTraceGases: 10))
        XCTAssertThrowsError(try Gas.init(percentOxygen: 90, percentNitrogen: 90, percentTraceGases: 90))
        XCTAssertThrowsError(try Gas.init(percentOxygen: -10, percentNitrogen: 10, percentTraceGases: 10, percentContaminantGases: 10))
        XCTAssertThrowsError(try Gas.init(percentOxygen: 10, percentNitrogen: -10, percentTraceGases: 10, percentContaminantGases: 10))
        XCTAssertThrowsError(try Gas.init(percentOxygen: 10, percentNitrogen: 10, percentTraceGases: -10, percentContaminantGases: 10))
        XCTAssertThrowsError(try Gas.init(percentOxygen: 10, percentNitrogen: 10, percentTraceGases: 10, percentContaminantGases: -10))
        XCTAssertThrowsError(try Gas.init(percentOxygen: 10, percentNitrogen: 10, percentTraceGases: 10, percentContaminantGases: 10))
        XCTAssertThrowsError(try Gas.init(percentOxygen: 90, percentNitrogen: 90, percentTraceGases: 90, percentContaminantGases: 90))
    }
}
