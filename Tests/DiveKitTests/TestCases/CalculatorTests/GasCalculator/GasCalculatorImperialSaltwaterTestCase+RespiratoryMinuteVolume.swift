import XCTest
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: respiratoryMinuteVolume(at:for:consuming:with:using:)

    func testRespiratoryMinuteVolumeValidInput() throws {
        // Given
        let depth: Depth = 40.0
        let minutes: Minutes = 15.0
        let consuming: Pressure = 450.0
        let tank = Tank.cubicFeet(142, ratedPressure: 2475, with: .air)

        // When
        try XCTAssertCalculation(
            sut.respiratoryMinuteVolume(
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

    func testRespiratoryMinuteVolumeInvalidDepthInput() throws {
        // Given
        let depth: Depth = -40.0
        let minutes: Minutes = 15.0
        let consuming: Pressure = 450.0
        let tank = Tank.cubicFeet(142, ratedPressure: 2475, with: .air)
        expectedError = .input(.negative(.depth(depth)), "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")

        // When
        try XCTAssertThrowsError(
            when: sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.depth")
            }
    }

    func testRespiratoryMinuteVolumeInvalidMinutesInput() throws {
        // Given
        let depth: Depth = 40.0
        let minutes: Minutes = -15.0
        let consuming: Pressure = 450.0
        let tank = Tank.cubicFeet(142, ratedPressure: 2475, with: .air)
        expectedError = .input(.negative(.minutes(minutes)), "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")

        // When
        try XCTAssertThrowsError(
            when: sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.minutes")
            }
    }

    func testRespiratoryMinuteVolumeInvalidConsumedInput() throws {
        // Given
        let depth: Depth = 40.0
        let minutes: Minutes = 15.0
        let consuming: Pressure = -450.0
        let tank = Tank.cubicFeet(142, ratedPressure: 2475, with: .air)
        expectedError = .input(.negative(.pressure(consuming)), "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")

        // When
        try XCTAssertThrowsError(
            when: sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.pressure")
            }
    }

    func testRespiratoryMinuteVolumeInvalidTankVolumeInput() throws {
        // Given
        let depth: Depth = 40.0
        let minutes: Minutes = 15.0
        let consuming: Pressure = 450.0
        let tank = Tank.cubicFeet(-142, ratedPressure: 2475, with: .air)
        expectedError = .input(.invalid(.tank(tank)), "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")

        // When
        try XCTAssertThrowsError(
            when: sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "invalid.tank")
            }
    }

    func testRespiratoryMinuteVolumeInvalidTankRatedPressureInput() throws {
        // Given
        let depth: Depth = 40.0
        let minutes: Minutes = 15.0
        let consuming: Pressure = 450.0
        let tank = Tank.cubicFeet(142, ratedPressure: -2475, with: .air)
        expectedError = .input(.invalid(.tank(tank)), "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")

        // When
        try XCTAssertThrowsError(
            when: sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "invalid.tank")
            }
    }
}
