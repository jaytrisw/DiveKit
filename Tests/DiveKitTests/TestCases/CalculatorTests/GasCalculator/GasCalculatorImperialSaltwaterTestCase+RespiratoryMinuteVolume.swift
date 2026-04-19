import Testing
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: respiratoryMinuteVolume(at:for:consuming:with:using:)

    @Test
    func testRespiratoryMinuteVolumeValidInput() throws {
        // Given
        let depth: Depth = 40.0
        let minutes: Minutes = 15.0
        let consuming: Pressure = 450.0
        let volume: Volume = 142
        let ratedPressure: Pressure = 2475
        let tank = Tank.cubicFeet(volume, ratedPressure: ratedPressure, with: .air)

        // When
        try expectCalculation(
            sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator)) { result, configuration in
                    // Then
                    expectEqual(result.value, 0.778082191780822)
                    expectEqual(result.unit, .perMinute(.cubicFeet))
                    expectEqual(configuration, sut.configuration)
                }
    }

    @Test
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
        try expectThrowsError(
            when: sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            then: expectedError) {
                expectEqual($0.localizationKey, "dive.kit.error.negative.depth")
            }
    }

    @Test
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
        try expectThrowsError(
            when: sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            then: expectedError) {
                expectEqual($0.localizationKey, "dive.kit.error.negative.minutes")
            }
    }

    @Test
    func testRespiratoryMinuteVolumeRejectsZeroMinutes() throws {
        // Given
        let depth: Depth = 40.0
        let minutes: Minutes = 0.0
        let consuming: Pressure = 450.0
        let volume: Volume = 142
        let ratedPressure: Pressure = 2475
        let tank = Tank.cubicFeet(volume, ratedPressure: ratedPressure, with: .air)
        expectedError = .range(.lowerBound(0, 0), "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")

        // When / Then
        try expectThrowsError(
            when: sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            then: expectedError) {
                expectEqual($0.localizationKey, "dive.kit.error.range.lower.bound")
            }
    }

    @Test
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
        try expectThrowsError(
            when: sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            then: expectedError) {
                expectEqual($0.localizationKey, "dive.kit.error.negative.pressure")
            }
    }

    @Test
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
        try expectThrowsError(
            when: sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            then: expectedError) {
                expectEqual($0.localizationKey, "dive.kit.error.tank.size.volume")
            }
    }

    @Test
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
        try expectThrowsError(
            when: sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            then: expectedError) {
                expectEqual($0.localizationKey, "dive.kit.error.tank.size.rated.pressure")
            }
    }
}
