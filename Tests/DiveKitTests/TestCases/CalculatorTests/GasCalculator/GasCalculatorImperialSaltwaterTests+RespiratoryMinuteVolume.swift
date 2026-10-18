import Testing
@testable import DiveKit
import DiveKitTestSupport

extension GasCalculatorImperialSaltwaterTests {

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
            return (depth: depth, minutes: minutes, consuming: consuming, tank: tank)
        } when: { input in
            try self.sut.respiratoryMinuteVolume(
                at: input.depth,
                for: input.minutes,
                consuming: input.consuming,
                with: input.tank,
                using: self.physicsCalculator)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                // (450 psi / 15 min) / (1 + 40 / 33) × 142 cu ft / 2475 psi = 0.77808219178082191… cu ft/min.
                #expect(result.value.isApproximately(0.778082191780822))
                #expect(result.unit == .perMinute(.cubicFeet))
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test
    func respiratoryMinuteVolumeWithLiterTank() async throws {
        try await given {
            let depth: Depth = 0
            let minutes: Minutes = 1
            let consuming: Pressure = 1
            let tank = Tank(
                blend: .air,
                size: .init(volume: 12, ratedPressure: 200, unit: .liters))
            return (depth: depth, minutes: minutes, consuming: consuming, tank: tank)
        } when: { input in
            try self.sut.respiratoryMinuteVolume(
                at: input.depth,
                for: input.minutes,
                consuming: input.consuming,
                with: input.tank,
                using: self.physicsCalculator)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(result.value.isApproximately(0.029218386, with: .loose))
                #expect(result.unit == .perMinute(.cubicFeet))
                #expect(configuration == self.sut.configuration)
            }
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
            let expectedError: Error = .negative(depth, "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            return (depth: depth, minutes: minutes, consuming: consuming, tank: tank, expectedError: expectedError)
        } when: { input in
            Result {
                try self.sut.respiratoryMinuteVolume(
                    at: input.depth,
                    for: input.minutes,
                    consuming: input.consuming,
                    with: input.tank,
                    using: self.physicsCalculator)
            }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.depth")
            }
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
            let expectedError: Error = .negative(minutes, "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            return (depth: depth, minutes: minutes, consuming: consuming, tank: tank, expectedError: expectedError)
        } when: { input in
            Result {
                try self.sut.respiratoryMinuteVolume(
                    at: input.depth,
                    for: input.minutes,
                    consuming: input.consuming,
                    with: input.tank,
                    using: self.physicsCalculator)
            }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.minutes")
            }
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
            let expectedError: Error = .range(.lowerBound(0, 0), "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            return (depth: depth, minutes: minutes, consuming: consuming, tank: tank, expectedError: expectedError)
        } when: { input in
            Result {
                try self.sut.respiratoryMinuteVolume(
                    at: input.depth,
                    for: input.minutes,
                    consuming: input.consuming,
                    with: input.tank,
                    using: self.physicsCalculator)
            }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.lower.bound")
            }
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
            let expectedError: Error = .negative(consuming, "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            return (depth: depth, minutes: minutes, consuming: consuming, tank: tank, expectedError: expectedError)
        } when: { input in
            Result {
                try self.sut.respiratoryMinuteVolume(
                    at: input.depth,
                    for: input.minutes,
                    consuming: input.consuming,
                    with: input.tank,
                    using: self.physicsCalculator)
            }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.pressure")
            }
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
            let expectedError: Error = .tank(.volume(volume, tank), "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            return (depth: depth, minutes: minutes, consuming: consuming, tank: tank, expectedError: expectedError)
        } when: { input in
            Result {
                try self.sut.respiratoryMinuteVolume(
                    at: input.depth,
                    for: input.minutes,
                    consuming: input.consuming,
                    with: input.tank,
                    using: self.physicsCalculator)
            }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.tank.size.volume")
            }
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
            let expectedError: Error = .tank(.ratedPressure(ratedPressure, tank), "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            return (depth: depth, minutes: minutes, consuming: consuming, tank: tank, expectedError: expectedError)
        } when: { input in
            Result {
                try self.sut.respiratoryMinuteVolume(
                    at: input.depth,
                    for: input.minutes,
                    consuming: input.consuming,
                    with: input.tank,
                    using: self.physicsCalculator)
            }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.tank.size.rated.pressure")
            }
        }
    }

    @Test(.tags(.error))
    func respiratoryMinuteVolumeZeroTankRatedPressureInput() async throws {
        try await given {
            let depth: Depth = 40.0
            let minutes: Minutes = 15.0
            let consuming: Pressure = 450.0
            let volume: Volume = 142
            let ratedPressure: Pressure = 0
            let tank = Tank.cubicFeet(volume, ratedPressure: ratedPressure, with: .air)
            let expectedError: Error = .tank(.ratedPressure(ratedPressure, tank), "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            return (depth: depth, minutes: minutes, consuming: consuming, tank: tank, expectedError: expectedError)
        } when: { input in
            Result {
                try self.sut.respiratoryMinuteVolume(
                    at: input.depth,
                    for: input.minutes,
                    consuming: input.consuming,
                    with: input.tank,
                    using: self.physicsCalculator)
            }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.tank.size.rated.pressure")
            }
        }
    }
}
