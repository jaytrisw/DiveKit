import Testing
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: respiratoryMinuteVolume(at:for:consuming:with:using:)

    @Test
    func respiratoryMinuteVolumeValidInput() throws {
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
                    #expect(result.value == 0.778082191780822)
                    #expect(result.unit == .perMinute(.cubicFeet))
                    #expect(configuration == sut.configuration)
                }
    }

    @Test(.tags(.error))
    func respiratoryMinuteVolumeInvalidDepthInput() throws {
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
                #expect($0.localizationValue == "dive.kit.error.negative.depth")
            }
    }

    @Test(.tags(.error))
    func respiratoryMinuteVolumeInvalidMinutesInput() throws {
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
                #expect($0.localizationValue == "dive.kit.error.negative.minutes")
            }
    }

    @Test(.tags(.error))
    func respiratoryMinuteVolumeRejectsZeroMinutes() throws {
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
                #expect($0.localizationValue == "dive.kit.error.range.lower.bound")
            }
    }

    @Test(.tags(.error))
    func respiratoryMinuteVolumeInvalidConsumedInput() throws {
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
                #expect($0.localizationValue == "dive.kit.error.negative.pressure")
            }
    }

    @Test(.tags(.error))
    func respiratoryMinuteVolumeInvalidTankVolumeInput() throws {
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
                #expect($0.localizationValue == "dive.kit.error.tank.size.volume")
            }
    }

    @Test(.tags(.error))
    func respiratoryMinuteVolumeInvalidTankRatedPressureInput() throws {
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
                #expect($0.localizationValue == "dive.kit.error.tank.size.rated.pressure")
            }
    }
}
