import TestUtility
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: respiratoryMinuteVolume(at:for:consuming:with:using:)

    func testRespiratoryMinuteVolumeValidInput() {
        // Given
        let depth: Depth = 40.0
        let minutes: Minutes = 15.0
        let consuming: Pressure = 450.0
        let tank = Tank.cubicFeet(142, ratedPressure: 2475, with: .air)

        // When
        XCTAssertCalculation(
            try sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator)) { result, configuration in
                    // Then
                    XCTAssertEqual(result.value, 0.778082191780822)
                    XCTAssertEqual(result.unit, .cubicFeet)
                    XCTAssertEqual(configuration, sut.configuration)
                }
    }

    func testRespiratoryMinuteVolumeInvalidDepthInput() {
        // Given
        let depth: Depth = -40.0
        let minutes: Minutes = 15.0
        let consuming: Pressure = 450.0
        let tank = Tank.cubicFeet(142, ratedPressure: 2475, with: .air)

        // When
        XCTAssertThrowsError(
            try sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            as: Error<Depth>.self) { error in
                // Then
                XCTAssertEqual(error.value, depth)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.depth")
                XCTAssertEqual(error.callSite, "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            }
    }

    func testRespiratoryMinuteVolumeInvalidMinutesInput() {
        // Given
        let depth: Depth = 40.0
        let minutes: Minutes = -15.0
        let consuming: Pressure = 450.0
        let tank = Tank.cubicFeet(142, ratedPressure: 2475, with: .air)

        // When
        XCTAssertThrowsError(
            try sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            as: Error<Minutes>.self) { error in
                // Then
                XCTAssertEqual(error.value, minutes)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.time")
                XCTAssertEqual(error.callSite, "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            }
    }

    func testRespiratoryMinuteVolumeInvalidConsumedInput() {
        // Given
        let depth: Depth = 40.0
        let minutes: Minutes = 15.0
        let consuming: Pressure = -450.0
        let tank = Tank.cubicFeet(142, ratedPressure: 2475, with: .air)

        // When
        XCTAssertThrowsError(
            try sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            as: Error<Pressure>.self) { error in
                // Then
                XCTAssertEqual(error.value, consuming)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.consumed")
                XCTAssertEqual(error.callSite, "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            }
    }

    func testRespiratoryMinuteVolumeInvalidTankVolumeInput() {
        // Given
        let depth: Depth = 40.0
        let minutes: Minutes = 15.0
        let consuming: Pressure = 450.0
        let tank = Tank.cubicFeet(-142, ratedPressure: 2475, with: .air)

        // When
        XCTAssertThrowsError(
            try sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            as: Error<Tank>.self) { error in
                // Then
                XCTAssertEqual(error.value, tank)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.invalid.tank")
                XCTAssertEqual(error.callSite, "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            }
    }

    func testRespiratoryMinuteVolumeInvalidTankRatedPressureInput() {
        // Given
        let depth: Depth = 40.0
        let minutes: Minutes = 15.0
        let consuming: Pressure = 450.0
        let tank = Tank.cubicFeet(142, ratedPressure: -2475, with: .air)

        // When
        XCTAssertThrowsError(
            try sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            as: Error<Tank>.self) { error in
                // Then
                XCTAssertEqual(error.value, tank)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.invalid.tank")
                XCTAssertEqual(error.callSite, "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            }
    }

}
