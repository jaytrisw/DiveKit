import Testing
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTests {

    // MARK: surfaceAirConsumption(at:for:consuming:using:)

    @Test
    func surfaceAirConsumptionConsumingValidInput() async throws {
        try await given {
            let depth: Depth = 90.0
            let minutes: Minutes = 10.0
            let consuming: Pressure = 600.0
            return (depth: depth, minutes: minutes, consuming: consuming)
        } when: { input in
            try self.sut.surfaceAirConsumption(
                at: input.depth,
                for: input.minutes,
                consuming: input.consuming,
                using: self.physicsCalculator)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(result.value == 16.097560975609756)
                #expect(result.unit == .perMinute(.psi))
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionConsumingInvalidDepthInput() async throws {
        try await given {
            let depth: Depth = -90.0
            let minutes: Minutes = 10.0
            let consuming: Pressure = 600.0
            let expectedError: Error = .negative(depth, "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)")
            return (depth: depth, minutes: minutes, consuming: consuming, expectedError: expectedError)
        } when: { input in
            Result {
                try self.sut.surfaceAirConsumption(
                    at: input.depth,
                    for: input.minutes,
                    consuming: input.consuming,
                    using: self.physicsCalculator)
            }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.depth")
            }
        }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionConsumingInvalidMinutesInput() async throws {
        try await given {
            let depth: Depth = 90.0
            let minutes: Minutes = -10.0
            let consuming: Pressure = 600.0
            let expectedError: Error = .negative(minutes, "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)")
            return (depth: depth, minutes: minutes, consuming: consuming, expectedError: expectedError)
        } when: { input in
            Result {
                try self.sut.surfaceAirConsumption(
                    at: input.depth,
                    for: input.minutes,
                    consuming: input.consuming,
                    using: self.physicsCalculator)
            }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.minutes")
            }
        }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionConsumingRejectsZeroMinutes() async throws {
        try await given {
            let depth: Depth = 90.0
            let minutes: Minutes = 0.0
            let consuming: Pressure = 600.0
            let expectedError: Error = .range(.lowerBound(0, 0), "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)")
            return (depth: depth, minutes: minutes, consuming: consuming, expectedError: expectedError)
        } when: { input in
            Result {
                try self.sut.surfaceAirConsumption(
                    at: input.depth,
                    for: input.minutes,
                    consuming: input.consuming,
                    using: self.physicsCalculator)
            }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.lower.bound")
            }
        }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionConsumingInvalidConsumingInput() async throws {
        try await given {
            let depth: Depth = 90.0
            let minutes: Minutes = 10.0
            let consuming: Pressure = -600.0
            let expectedError: Error = .negative(consuming, "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)")
            return (depth: depth, minutes: minutes, consuming: consuming, expectedError: expectedError)
        } when: { input in
            Result {
                try self.sut.surfaceAirConsumption(
                    at: input.depth,
                    for: input.minutes,
                    consuming: input.consuming,
                    using: self.physicsCalculator)
            }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.pressure")
            }
        }
    }

    // MARK: surfaceAirConsumption(at:for:start:end:using:)

    @Test
    func surfaceAirConsumptionStartEndValidInput() async throws {
        try await given {
            let depth: Depth = 90.0
            let minutes: Minutes = 10.0
            let startPressure: Pressure = 3000.0
            let endPressure: Pressure = 2400.0
            return (depth: depth, minutes: minutes, startPressure: startPressure, endPressure: endPressure)
        } when: { input in
            try self.sut.surfaceAirConsumption(
                at: input.depth,
                for: input.minutes,
                start: input.startPressure,
                end: input.endPressure,
                using: self.physicsCalculator)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(result.value == 16.097560975609756)
                #expect(result.unit == .perMinute(.psi))
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionStartEndInvalidDepthInput() async throws {
        try await given {
            let depth: Depth = -90.0
            let minutes: Minutes = 10.0
            let startPressure: Pressure = 3000.0
            let endPressure: Pressure = 2400.0
            let expectedError: Error = .negative(depth, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
            return (depth: depth, minutes: minutes, startPressure: startPressure, endPressure: endPressure, expectedError: expectedError)
        } when: { input in
            Result {
                try self.sut.surfaceAirConsumption(
                    at: input.depth,
                    for: input.minutes,
                    start: input.startPressure,
                    end: input.endPressure,
                    using: self.physicsCalculator)
            }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.depth")
            }
        }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionStartEndInvalidTimeInput() async throws {
        try await given {
            let depth: Depth = 90.0
            let minutes: Minutes = -10.0
            let startPressure: Pressure = 3000.0
            let endPressure: Pressure = 2400.0
            let expectedError: Error = .negative(minutes, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
            return (depth: depth, minutes: minutes, startPressure: startPressure, endPressure: endPressure, expectedError: expectedError)
        } when: { input in
            Result {
                try self.sut.surfaceAirConsumption(
                    at: input.depth,
                    for: input.minutes,
                    start: input.startPressure,
                    end: input.endPressure,
                    using: self.physicsCalculator)
            }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.minutes")
            }
        }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionStartEndInvalidStartPressureInput() async throws {
        try await given {
            let depth: Depth = 90.0
            let minutes: Minutes = 10.0
            let startPressure: Pressure = -3000.0
            let endPressure: Pressure = 2400.0
            let expectedError: Error = .negative(startPressure, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
            return (depth: depth, minutes: minutes, startPressure: startPressure, endPressure: endPressure, expectedError: expectedError)
        } when: { input in
            Result {
                try self.sut.surfaceAirConsumption(
                    at: input.depth,
                    for: input.minutes,
                    start: input.startPressure,
                    end: input.endPressure,
                    using: self.physicsCalculator)
            }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.pressure")
            }
        }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionStartEndInvalidEndPressureInput() async throws {
        try await given {
            let depth: Depth = 90.0
            let minutes: Minutes = 10.0
            let startPressure: Pressure = 3000.0
            let endPressure: Pressure = -2400.0
            let expectedError: Error = .negative(endPressure, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
            return (depth: depth, minutes: minutes, startPressure: startPressure, endPressure: endPressure, expectedError: expectedError)
        } when: { input in
            Result {
                try self.sut.surfaceAirConsumption(
                    at: input.depth,
                    for: input.minutes,
                    start: input.startPressure,
                    end: input.endPressure,
                    using: self.physicsCalculator)
            }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.pressure")
            }
        }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionStartEndInvalidCalculatedConsumingPressureInput() async throws {
        try await given {
            let depth: Depth = 90.0
            let minutes: Minutes = 10.0
            let startPressure: Pressure = 2400.0
            let endPressure: Pressure = 3000.0
            let consumed: Pressure = -600
            let expectedError: Error = .negative(consumed, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
            return (depth: depth, minutes: minutes, startPressure: startPressure, endPressure: endPressure, expectedError: expectedError)
        } when: { input in
            Result {
                try self.sut.surfaceAirConsumption(
                    at: input.depth,
                    for: input.minutes,
                    start: input.startPressure,
                    end: input.endPressure,
                    using: self.physicsCalculator)
            }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.pressure")
            }
        }
    }

}
