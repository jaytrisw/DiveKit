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
            return {
                try expectCalculation(
                    self.sut.surfaceAirConsumption(
                        at: depth,
                        for: minutes,
                        consuming: consuming,
                        using: self.physicsCalculator)) { result, configuration in
                            #expect(result.value == 16.097560975609756)
                            #expect(result.unit == .perMinute(.psi))
                            #expect(configuration == self.sut.configuration)
                        }
            }
        } when: { operation in
            try operation()
        }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionConsumingInvalidDepthInput() async throws {
        try await given {
            let depth: Depth = -90.0
            let minutes: Minutes = 10.0
            let consuming: Pressure = 600.0
            self.expectedError = .negative(depth, "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)")
            return {
                try expectThrowsError(
                    when: self.sut.surfaceAirConsumption(
                        at: depth,
                        for: minutes,
                        consuming: consuming,
                        using: self.physicsCalculator),
                    then: self.expectedError) {
                        #expect($0.localizationValue == "dive.kit.error.negative.depth")
                    }
            }
        } when: { operation in
            try operation()
        }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionConsumingInvalidMinutesInput() async throws {
        try await given {
            let depth: Depth = 90.0
            let minutes: Minutes = -10.0
            let consuming: Pressure = 600.0
            self.expectedError = .negative(minutes, "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)")
            return {
                try expectThrowsError(
                    when: self.sut.surfaceAirConsumption(
                        at: depth,
                        for: minutes,
                        consuming: consuming,
                        using: self.physicsCalculator),
                    then: self.expectedError) {
                        #expect($0.localizationValue == "dive.kit.error.negative.minutes")
                    }
            }
        } when: { operation in
            try operation()
        }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionConsumingRejectsZeroMinutes() async throws {
        try await given {
            let depth: Depth = 90.0
            let minutes: Minutes = 0.0
            let consuming: Pressure = 600.0
            self.expectedError = .range(.lowerBound(0, 0), "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)")
            return {
                try expectThrowsError(
                    when: self.sut.surfaceAirConsumption(
                        at: depth,
                        for: minutes,
                        consuming: consuming,
                        using: self.physicsCalculator),
                    then: self.expectedError) {
                        #expect($0.localizationValue == "dive.kit.error.range.lower.bound")
                    }
            }
        } when: { operation in
            try operation()
        }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionConsumingInvalidConsumingInput() async throws {
        try await given {
            let depth: Depth = 90.0
            let minutes: Minutes = 10.0
            let consuming: Pressure = -600.0
            self.expectedError = .negative(consuming, "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)")
            return {
                try expectThrowsError(
                    when:
                        self.sut.surfaceAirConsumption(
                            at: depth,
                            for: minutes,
                            consuming: consuming,
                            using: self.physicsCalculator),
                    then: self.expectedError) {
                        #expect($0.localizationValue == "dive.kit.error.negative.pressure")
                    }
            }
        } when: { operation in
            try operation()
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
            return {
                try expectCalculation(
                    self.sut.surfaceAirConsumption(
                        at: depth,
                        for: minutes,
                        start: startPressure,
                        end: endPressure,
                        using: self.physicsCalculator)) { result, configuration in
                            #expect(result.value == 16.097560975609756)
                            #expect(result.unit == .perMinute(.psi))
                            #expect(configuration == self.sut.configuration)
                        }
            }
        } when: { operation in
            try operation()
        }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionStartEndInvalidDepthInput() async throws {
        try await given {
            let depth: Depth = -90.0
            let minutes: Minutes = 10.0
            let startPressure: Pressure = 3000.0
            let endPressure: Pressure = 2400.0
            self.expectedError = .negative(depth, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
            return {
                try expectThrowsError(
                    when: self.sut.surfaceAirConsumption(
                        at: depth,
                        for: minutes,
                        start: startPressure,
                        end: endPressure,
                        using: self.physicsCalculator),
                    then: self.expectedError) {
                        #expect($0.localizationValue == "dive.kit.error.negative.depth")
                    }
            }
        } when: { operation in
            try operation()
        }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionStartEndInvalidTimeInput() async throws {
        try await given {
            let depth: Depth = 90.0
            let minutes: Minutes = -10.0
            let startPressure: Pressure = 3000.0
            let endPressure: Pressure = 2400.0
            self.expectedError = .negative(minutes, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
            return {
                try expectThrowsError(
                    when: self.sut.surfaceAirConsumption(
                        at: depth,
                        for: minutes,
                        start: startPressure,
                        end: endPressure,
                        using: self.physicsCalculator),
                    then: self.expectedError) {
                        #expect($0.localizationValue == "dive.kit.error.negative.minutes")
                    }
            }
        } when: { operation in
            try operation()
        }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionStartEndInvalidStartPressureInput() async throws {
        try await given {
            let depth: Depth = 90.0
            let minutes: Minutes = 10.0
            let startPressure: Pressure = -3000.0
            let endPressure: Pressure = 2400.0
            self.expectedError = .negative(startPressure, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
            return {
                try expectThrowsError(
                    when: self.sut.surfaceAirConsumption(
                        at: depth,
                        for: minutes,
                        start: startPressure,
                        end: endPressure,
                        using: self.physicsCalculator),
                    then: self.expectedError) {
                        #expect($0.localizationValue == "dive.kit.error.negative.pressure")
                    }
            }
        } when: { operation in
            try operation()
        }
    }

    @Test(.tags(.error))
    func surfaceAirConsumptionStartEndInvalidEndPressureInput() async throws {
        try await given {
            let depth: Depth = 90.0
            let minutes: Minutes = 10.0
            let startPressure: Pressure = 3000.0
            let endPressure: Pressure = -2400.0
            self.expectedError = .negative(endPressure, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
            return {
                try expectThrowsError(
                    when: self.sut.surfaceAirConsumption(
                        at: depth,
                        for: minutes,
                        start: startPressure,
                        end: endPressure,
                        using: self.physicsCalculator),
                    then: self.expectedError) {
                        #expect($0.localizationValue == "dive.kit.error.negative.pressure")
                    }
            }
        } when: { operation in
            try operation()
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
            self.expectedError = .negative(consumed, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
            return {
                try expectThrowsError(
                    when: self.sut.surfaceAirConsumption(
                        at: depth,
                        for: minutes,
                        start: startPressure,
                        end: endPressure,
                        using: self.physicsCalculator),
                    then: self.expectedError) {
                        #expect($0.localizationValue == "dive.kit.error.negative.pressure")
                    }
            }
        } when: { operation in
            try operation()
        }
    }

}
