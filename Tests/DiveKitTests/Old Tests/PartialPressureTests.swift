import XCTest
@testable import DiveKit

final class PartialPressureTests: XCTestCase {
    func testThrowingInitializers() {
        XCTAssertThrowsError(try PartialPressure.init(fractionOxygen: -0.68, fractionNitrogen: 0.68))
        XCTAssertThrowsError(try PartialPressure.init(fractionOxygen: 0.68, fractionNitrogen: -0.68))
        XCTAssertThrowsError(try PartialPressure.init(fractionOxygen: 0.68, fractionNitrogen: 0.68))
        XCTAssertThrowsError(try PartialPressure.init(fractionOxygen: 0.48, fractionNitrogen: 0.48))
        XCTAssertThrowsError(try PartialPressure.init(fractionOxygen: -0.68, fractionNitrogen: 0.68, fractionContaminantGases: 0.68))
        XCTAssertThrowsError(try PartialPressure.init(fractionOxygen: -0.68, fractionNitrogen: 0.68, fractionContaminantGases: 0.68))
        XCTAssertThrowsError(try PartialPressure.init(fractionOxygen: 0.68, fractionNitrogen: 0.68, fractionContaminantGases: -0.68))
        XCTAssertThrowsError(try PartialPressure.init(fractionOxygen: 0.68, fractionNitrogen: 0.68, fractionContaminantGases: 0.68))
        XCTAssertThrowsError(try PartialPressure.init(fractionOxygen: 0.18, fractionNitrogen: 0.18, fractionContaminantGases: 0.18))
        XCTAssertThrowsError(try PartialPressure.init(fractionOxygen: -0.68, fractionNitrogen: 0.68, fractionTraceGases: 0.68))
        XCTAssertThrowsError(try PartialPressure.init(fractionOxygen: 0.68, fractionNitrogen: -0.68, fractionTraceGases: 0.68))
        XCTAssertThrowsError(try PartialPressure.init(fractionOxygen: 0.68, fractionNitrogen: 0.68, fractionTraceGases: -0.68))
        XCTAssertThrowsError(try PartialPressure.init(fractionOxygen: 0.68, fractionNitrogen: 0.68, fractionTraceGases: 0.68))
        XCTAssertThrowsError(try PartialPressure.init(fractionOxygen: 0.18, fractionNitrogen: 0.18, fractionTraceGases: 0.18))
        XCTAssertThrowsError(try PartialPressure.init(fractionOxygen: -0.68, fractionNitrogen: 0.68, fractionContaminantGases: 0.68, fractionTraceGases: 0.68))
        XCTAssertThrowsError(try PartialPressure.init(fractionOxygen: 0.68, fractionNitrogen: -0.68, fractionContaminantGases: 0.68, fractionTraceGases: 0.68))
        XCTAssertThrowsError(try PartialPressure.init(fractionOxygen: 0.68, fractionNitrogen: 0.68, fractionContaminantGases: -0.68, fractionTraceGases: 0.68))
        XCTAssertThrowsError(try PartialPressure.init(fractionOxygen: 0.68, fractionNitrogen: 0.68, fractionContaminantGases: 0.68, fractionTraceGases: -0.68))
        XCTAssertThrowsError(try PartialPressure.init(fractionOxygen: 0.68, fractionNitrogen: 0.68, fractionContaminantGases: 0.68, fractionTraceGases: 0.68))
        XCTAssertThrowsError(try PartialPressure.init(fractionOxygen: 0.18, fractionNitrogen: 0.18, fractionContaminantGases: 0.18, fractionTraceGases: 0.18))
        XCTAssertThrowsError(try PartialPressure.init(fractionOxygen: 0.18, fractionNitrogen: 0.18, fractionHelium: -0.18))
        XCTAssertThrowsError(try PartialPressure.init(fractionOxygen: 0, fractionNitrogen: 0, fractionHelium: 1.18))
        let partialPressure = try! PartialPressure(fractionOxygen: 0.32, fractionNitrogen: 0.68)
        XCTAssertEqual(partialPressure.fractionOxygen, 0.32)
        XCTAssertEqual(partialPressure.fractionNitrogen, 0.68)
        XCTAssertEqual(partialPressure.fractionHelium, 0)
        XCTAssertEqual(partialPressure.fractionTraceGases, 0)
        XCTAssertEqual(partialPressure.fractionContaminantGases, 0)
    }
}
