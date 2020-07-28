import XCTest
@testable import DiveKit

final class DiveKitTests: XCTestCase {

    func testInitializers() {
        var diveKit = DiveKit.default
        XCTAssertEqual(diveKit.measurementUnit, DiveKit.MeasurementUnit.imperial)
        XCTAssertEqual(diveKit.waterType, DiveKit.WaterType.saltWater)
        XCTAssertEqual(diveKit.measurementUnit.units.depthUnit, "foot")
        diveKit = DiveKit.init(waterType: .saltWater, measurementUnit: .metric)
        XCTAssertEqual(diveKit.measurementUnit, DiveKit.MeasurementUnit.metric)
        XCTAssertEqual(diveKit.waterType, DiveKit.WaterType.saltWater)
        diveKit = DiveKit.init(waterType: .freshWater, measurementUnit: .imperial)
        XCTAssertEqual(diveKit.measurementUnit, DiveKit.MeasurementUnit.imperial)
        XCTAssertEqual(diveKit.waterType, DiveKit.WaterType.freshWater)
        diveKit = DiveKit.init(waterType: .freshWater, measurementUnit: .metric)
        XCTAssertEqual(diveKit.measurementUnit, DiveKit.MeasurementUnit.metric)
        XCTAssertEqual(diveKit.waterType, DiveKit.WaterType.freshWater)
        XCTAssertEqual(diveKit.measurementUnit.description, "Metric")
        XCTAssertEqual(diveKit.waterType.description, "Freshwater")
        XCTAssertEqual(diveKit.measurementUnit.units.depthUnit, "metre")
    }
}
