import Testing
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: surfaceAirConsumption(at:for:consuming:using:)

    @Test
    func surfaceAirConsumptionConsumingValidInput() throws {
        // Given
        let depth: Depth = 90.0
        let minutes: Minutes = 10.0
        let consuming: Pressure = 600.0

        // When
        try expectCalculation(
            sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                consuming: consuming,
                using: physicsCalculator)) { result, configuration in
                    // Then
                    #expect(result.value == 16.097560975609756)
                    #expect(result.unit == .perMinute(.psi))
                    #expect(configuration == sut.configuration)
                }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionConsumingInvalidDepthInput() throws {
        // Given
        let depth: Depth = -90.0
        let minutes: Minutes = 10.0
        let consuming: Pressure = 600.0
        expectedError = .negative(depth, "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)")

        // When
        try expectThrowsError(
            when: sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                consuming: consuming,
                using: physicsCalculator),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.depth")
            }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionConsumingInvalidMinutesInput() throws {
        // Given
        let depth: Depth = 90.0
        let minutes: Minutes = -10.0
        let consuming: Pressure = 600.0
        expectedError = .negative(minutes, "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)")

        // When
        try expectThrowsError(
            when: sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                consuming: consuming,
                using: physicsCalculator),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.minutes")
            }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionConsumingRejectsZeroMinutes() throws {
        // Given
        let depth: Depth = 90.0
        let minutes: Minutes = 0.0
        let consuming: Pressure = 600.0
        expectedError = .range(.lowerBound(0, 0), "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)")

        // When / Then
        try expectThrowsError(
            when: sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                consuming: consuming,
                using: physicsCalculator),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.lower.bound")
            }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionConsumingInvalidConsumingInput() throws {
        // Given
        let depth: Depth = 90.0
        let minutes: Minutes = 10.0
        let consuming: Pressure = -600.0
        expectedError = .negative(consuming, "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)")

        // When
        try expectThrowsError(
            when:
                sut.surfaceAirConsumption(
                    at: depth,
                    for: minutes,
                    consuming: consuming,
                    using: physicsCalculator),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.pressure")
            }
    }

    // MARK: surfaceAirConsumption(at:for:start:end:using:)

    @Test
    func surfaceAirConsumptionStartEndValidInput() throws {
        // Given
        let depth: Depth = 90.0
        let minutes: Minutes = 10.0
        let startPressure: Pressure = 3000.0
        let endPressure: Pressure = 2400.0

        // When
        try expectCalculation(
            sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator)) { result, configuration in
                    // Then
                    #expect(result.value == 16.097560975609756)
                    #expect(result.unit == .perMinute(.psi))
                    #expect(configuration == sut.configuration)
                }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionStartEndInvalidDepthInput() throws {
        // Given
        let depth: Depth = -90.0
        let minutes: Minutes = 10.0
        let startPressure: Pressure = 3000.0
        let endPressure: Pressure = 2400.0
        expectedError = .negative(depth, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")

        // When
        try expectThrowsError(
            when: sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.depth")
            }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionStartEndInvalidTimeInput() throws {
        // Given
        let depth: Depth = 90.0
        let minutes: Minutes = -10.0
        let startPressure: Pressure = 3000.0
        let endPressure: Pressure = 2400.0
        expectedError = .negative(minutes, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")

        // When
        try expectThrowsError(
            when: sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.minutes")
            }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionStartEndInvalidStartPressureInput() throws {
        // Given
        let depth: Depth = 90.0
        let minutes: Minutes = 10.0
        let startPressure: Pressure = -3000.0
        let endPressure: Pressure = 2400.0
        expectedError = .negative(startPressure, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")

        // When
        try expectThrowsError(
            when: sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.pressure")
            }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionStartEndInvalidEndPressureInput() throws {
        // Given
        let depth: Depth = 90.0
        let minutes: Minutes = 10.0
        let startPressure: Pressure = 3000.0
        let endPressure: Pressure = -2400.0
        expectedError = .negative(endPressure, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")

        // When
        try expectThrowsError(
            when: sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.pressure")
            }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionStartEndInvalidCalculatedConsumingPressureInput() throws {
        // Given
        let depth: Depth = 90.0
        let minutes: Minutes = 10.0
        let startPressure: Pressure = 2400.0
        let endPressure: Pressure = 3000.0
        let consumed: Pressure = -600
        expectedError = .negative(consumed, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")

        // When
        try expectThrowsError(
            when: sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.pressure")
            }
    }

}
