//
//  CalculationTypeTests.swift
//  
//
//  Created by Joshua Wood on 7/9/20.
//

import XCTest
@testable import DiveKit

final class CalculationTypeTests: XCTestCase {
    func testCalculationType() {
        let calculation = Calculation.respiratoryMinuteVolume(value: 15.55, diveKit: DiveKit.init())
        XCTAssertEqual(calculation, 15.55)
        XCTAssertEqual(calculation.round(to: 1), 15.6)
        let calculationFromString = Calculation("1000")
        XCTAssertEqual(calculationFromString, 1000)
        XCTAssertEqual(calculationFromString?.description, "1000.0")
        XCTAssertTrue(calculation < calculationFromString!)
        XCTAssertNotEqual(calculation.hashValue, calculationFromString.hashValue)
        XCTAssertNil(Calculation("This is a string"))
    }
}
