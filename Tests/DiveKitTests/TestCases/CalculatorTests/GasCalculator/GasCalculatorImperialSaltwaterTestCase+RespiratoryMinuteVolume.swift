import Testing
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: respiratoryMinuteVolume(at:for:consuming:with:using:)

    @Test
    func respiratoryMinuteVolumeValidInput() async throws {
        try await given {
            let depth: Depth = 40.0
            let minutes: Minutes = 15.0
            let consuming: Pressure = 450.0
            let volume: Volume = 142
            let ratedPressure: Pressure = 2475
            let tank = Tank.cubicFeet(volume, ratedPressure: ratedPressure, with: .air)
            return {
                try expectCalculation(
                    self.sut.respiratoryMinuteVolume(
                        at: depth,
                        for: minutes,
                        consuming: consuming,
                        with: tank,
                        using: self.physicsCalculator)) { result, configuration in
                            #expect(result.value == 0.778082191780822)
                            #expect(result.unit == .perMinute(.cubicFeet))
                            #expect(configuration == self.sut.configuration)
                        }
            }
        } when: { operation in
            try operation()
        }
    }

    @Test(.tags(.error))
    func respiratoryMinuteVolumeInvalidDepthInput() async throws {
        try await given {
            let depth: Depth = -40.0
            let minutes: Minutes = 15.0
            let consuming: Pressure = 450.0
            let volume: Volume = 142
            let ratedPressure: Pressure = 2475
            let tank = Tank.cubicFeet(volume, ratedPressure: ratedPressure, with: .air)
            self.expectedError = .negative(depth, "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            return {
                try expectThrowsError(
                    when: self.sut.respiratoryMinuteVolume(
                        at: depth,
                        for: minutes,
                        consuming: consuming,
                        with: tank,
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
    func respiratoryMinuteVolumeInvalidMinutesInput() async throws {
        try await given {
            let depth: Depth = 40.0
            let minutes: Minutes = -15.0
            let consuming: Pressure = 450.0
            let volume: Volume = 142
            let ratedPressure: Pressure = 2475
            let tank = Tank.cubicFeet(volume, ratedPressure: ratedPressure, with: .air)
            self.expectedError = .negative(minutes, "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            return {
                try expectThrowsError(
                    when: self.sut.respiratoryMinuteVolume(
                        at: depth,
                        for: minutes,
                        consuming: consuming,
                        with: tank,
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
    func respiratoryMinuteVolumeRejectsZeroMinutes() async throws {
        try await given {
            let depth: Depth = 40.0
            let minutes: Minutes = 0.0
            let consuming: Pressure = 450.0
            let volume: Volume = 142
            let ratedPressure: Pressure = 2475
            let tank = Tank.cubicFeet(volume, ratedPressure: ratedPressure, with: .air)
            self.expectedError = .range(.lowerBound(0, 0), "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            return {
                try expectThrowsError(
                    when: self.sut.respiratoryMinuteVolume(
                        at: depth,
                        for: minutes,
                        consuming: consuming,
                        with: tank,
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
    func respiratoryMinuteVolumeInvalidConsumedInput() async throws {
        try await given {
            let depth: Depth = 40.0
            let minutes: Minutes = 15.0
            let consuming: Pressure = -450.0
            let volume: Volume = 142
            let ratedPressure: Pressure = 2475
            let tank = Tank.cubicFeet(volume, ratedPressure: ratedPressure, with: .air)
            self.expectedError = .negative(consuming, "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            return {
                try expectThrowsError(
                    when: self.sut.respiratoryMinuteVolume(
                        at: depth,
                        for: minutes,
                        consuming: consuming,
                        with: tank,
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
    func respiratoryMinuteVolumeInvalidTankVolumeInput() async throws {
        try await given {
            let depth: Depth = 40.0
            let minutes: Minutes = 15.0
            let consuming: Pressure = 450.0
            let volume: Volume = -142
            let ratedPressure: Pressure = 2475
            let tank = Tank.cubicFeet(volume, ratedPressure: ratedPressure, with: .air)
            self.expectedError = .tank(.volume(volume, tank), "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            return {
                try expectThrowsError(
                    when: self.sut.respiratoryMinuteVolume(
                        at: depth,
                        for: minutes,
                        consuming: consuming,
                        with: tank,
                        using: self.physicsCalculator),
                    then: self.expectedError) {
                        #expect($0.localizationValue == "dive.kit.error.tank.size.volume")
                    }
            }
        } when: { operation in
            try operation()
        }
    }

    @Test(.tags(.error))
    func respiratoryMinuteVolumeInvalidTankRatedPressureInput() async throws {
        try await given {
            let depth: Depth = 40.0
            let minutes: Minutes = 15.0
            let consuming: Pressure = 450.0
            let volume: Volume = 142
            let ratedPressure: Pressure = -2475
            let tank = Tank.cubicFeet(volume, ratedPressure: ratedPressure, with: .air)
            self.expectedError = .tank(.ratedPressure(ratedPressure, tank), "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            return {
                try expectThrowsError(
                    when: self.sut.respiratoryMinuteVolume(
                        at: depth,
                        for: minutes,
                        consuming: consuming,
                        with: tank,
                        using: self.physicsCalculator),
                    then: self.expectedError) {
                        #expect($0.localizationValue == "dive.kit.error.tank.size.rated.pressure")
                    }
            }
        } when: { operation in
            try operation()
        }
    }
}
