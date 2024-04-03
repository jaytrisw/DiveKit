import TestUtility
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: surfaceAirConsumption(at:for:consuming:using:)

    func testSurfaceAirConsumptionConsumingValidInput() throws {
        // Given
        let depth = 90.0
        let minutes = 10.0
        let consuming = 600.0

        // When
        XCTAssertCalculation(
            try sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                consuming: consuming,
                using: physicsCalculator)) { result, configuration in
                    // Then
                    XCTAssertEqual(result.value, 16.097560975609756)
                    XCTAssertEqual(result.unit, .psi)
                    XCTAssertEqual(configuration, sut.configuration)
                }
    }

    func testSurfaceAirConsumptionConsumingInvalidDepthInput() throws {
        // Given
        let depth = -90.0
        let minutes = 10.0
        let consuming = 600.0

        // When
        XCTAssertThrowsError(
            try sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                consuming: consuming,
                using: physicsCalculator),
            as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, depth)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.depth")
                XCTAssertEqual(error.callSite, "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)")
            }
    }

    func testSurfaceAirConsumptionConsumingInvalidMinutesInput() throws {
        // Given
        let depth = 90.0
        let minutes = -10.0
        let consuming = 600.0

        // When
        XCTAssertThrowsError(
            try sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                consuming: consuming,
                using: physicsCalculator),
            as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, minutes)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.time")
                XCTAssertEqual(error.callSite, "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)")
            }
    }

    func testSurfaceAirConsumptionConsumingInvalidConsumingInput() throws {
        // Given
        let depth = 90.0
        let minutes = 10.0
        let consuming = -600.0

        // When
        XCTAssertThrowsError(
            try sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                consuming: consuming,
                using: physicsCalculator),
            as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, consuming)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.consumed")
                XCTAssertEqual(error.callSite, "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)")
            }
    }

    // MARK: surfaceAirConsumption(at:for:start:end:using:)

    func testSurfaceAirConsumptionStartEndValidInput() throws {
        // Given
        let depth = 90.0
        let minutes = 10.0
        let startPressure = 3000.0
        let endPressure = 2400.0

        // When
        XCTAssertCalculation(
            try sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator)) { result, configuration in
                    // Then
                    XCTAssertEqual(result.value, 16.097560975609756)
                    XCTAssertEqual(result.unit, .psi)
                    XCTAssertEqual(configuration, sut.configuration)
                }
    }

    func testSurfaceAirConsumptionStartEndInvalidDepthInput() throws {
        // Given
        let depth = -90.0
        let minutes = 10.0
        let startPressure = 3000.0
        let endPressure = 2400.0

        // When
        XCTAssertThrowsError(
            try sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator),
            as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, depth)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.depth")
                XCTAssertEqual(error.callSite, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
            }
    }

    func testSurfaceAirConsumptionStartEndInvalidTimeInput() throws {
        // Given
        let depth = 90.0
        let minutes = -10.0
        let startPressure = 3000.0
        let endPressure = 2400.0

        // When
        XCTAssertThrowsError(
            try sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator),
            as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, minutes)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.time")
                XCTAssertEqual(error.callSite, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
            }
    }

    func testSurfaceAirConsumptionStartEndInvalidStartPressureInput() throws {
        // Given
        let depth = 90.0
        let minutes = 10.0
        let startPressure = -3000.0
        let endPressure = 2400.0

        // When
        XCTAssertThrowsError(
            try sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator),
            as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, startPressure)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.start.pressure")
                XCTAssertEqual(error.callSite, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
            }
    }

    func testSurfaceAirConsumptionStartEndInvalidEndPressureInput() throws {
        // Given
        let depth = 90.0
        let minutes = 10.0
        let startPressure = 3000.0
        let endPressure = -2400.0

        // When
        XCTAssertThrowsError(
            try sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator),
            as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, endPressure)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.end.pressure")
                XCTAssertEqual(error.callSite, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
            }
    }

    func testSurfaceAirConsumptionStartEndInvalidCalculatedConsumingPressureInput() throws {
        // Given
        let depth = 90.0
        let minutes = 10.0
        let startPressure = 2400.0
        let endPressure = 3000.0

        // When
        XCTAssertThrowsError(
            try sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator),
            as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, startPressure - endPressure)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.consumed")
                XCTAssertEqual(error.callSite, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
            }
    }

}
