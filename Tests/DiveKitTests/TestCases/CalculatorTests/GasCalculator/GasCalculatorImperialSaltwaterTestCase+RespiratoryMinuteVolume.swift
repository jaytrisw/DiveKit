import XCTest
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: respiratoryMinuteVolume(at:for:consuming:with:using:)

    func testRespiratoryMinuteVolumeValidInput() throws {
        // Given
        let depth: Depth = 40.0
        let minutes: Minutes = 15.0
        let consuming: Pressure = 450.0
        let volume: Volume = 142
        let ratedPressure: Pressure = 2475
        let tank = Tank.cubicFeet(volume, ratedPressure: ratedPressure, with: .air)

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
        let volume: Volume = 142
        let ratedPressure: Pressure = 2475
        let tank = Tank.cubicFeet(volume, ratedPressure: ratedPressure, with: .air)
        expectedError = .negative(depth, "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")

        // When
        try XCTAssertThrowsError(
            when: sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "dive.kit.error.negative.depth")
            }
    }

    func testRespiratoryMinuteVolumeInvalidMinutesInput() throws {
        // Given
        let depth: Depth = 40.0
        let minutes: Minutes = -15.0
        let consuming: Pressure = 450.0
        let volume: Volume = 142
        let ratedPressure: Pressure = 2475
        let tank = Tank.cubicFeet(volume, ratedPressure: ratedPressure, with: .air)
        expectedError = .negative(minutes, "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")

        // When
        try XCTAssertThrowsError(
            when: sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "dive.kit.error.negative.minutes")
            }
    }

    func testRespiratoryMinuteVolumeInvalidConsumedInput() throws {
        // Given
        let depth: Depth = 40.0
        let minutes: Minutes = 15.0
        let consuming: Pressure = -450.0
        let volume: Volume = 142
        let ratedPressure: Pressure = 2475
        let tank = Tank.cubicFeet(volume, ratedPressure: ratedPressure, with: .air)
        expectedError = .negative(consuming, "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")

        // When
        try XCTAssertThrowsError(
            when: sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "dive.kit.error.negative.pressure")
            }
    }

    func testRespiratoryMinuteVolumeInvalidTankVolumeInput() throws {
        // Given
        let depth: Depth = 40.0
        let minutes: Minutes = 15.0
        let consuming: Pressure = 450.0
        let volume: Volume = -142
        let ratedPressure: Pressure = 2475
        let tank = Tank.cubicFeet(volume, ratedPressure: ratedPressure, with: .air)
        expectedError = .tank(.volume(volume, tank), "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")

        // When
        try XCTAssertThrowsError(
            when: sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "dive.kit.error.tank.size.volume")
            }
    }

    func testRespiratoryMinuteVolumeInvalidTankRatedPressureInput() throws {
        // Given
        let depth: Depth = 40.0
        let minutes: Minutes = 15.0
        let consuming: Pressure = 450.0
        let volume: Volume = 142
        let ratedPressure: Pressure = -2475
        let tank = Tank.cubicFeet(volume, ratedPressure: ratedPressure, with: .air)
        expectedError = .tank(.ratedPressure(ratedPressure, tank), "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")

        // When
        try XCTAssertThrowsError(
            when: sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "dive.kit.error.tank.size.rated.pressure")
            }
    }
}
