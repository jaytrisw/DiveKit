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

    /// One invalid argument per case. The others are the valid inputs of
    /// `respiratoryMinuteVolumeValidInput`: 40 ft, 15 minutes, 450 psi and a
    /// 142 cu ft, 2475 psi tank.
    enum InvalidRespiratoryMinuteVolumeInput: CaseIterable, Sendable {
        case negativeDepth
        case negativeMinutes
        case zeroMinutes
        case negativeConsumed
        case negativeTankVolume
        case negativeRatedPressure
        case zeroRatedPressure

        static let callSite: CallSite = "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)"

        var depth: Depth { self == .negativeDepth ? -40 : 40 }
        var minutes: Minutes { self == .negativeMinutes ? -15 : self == .zeroMinutes ? 0 : 15 }
        var consuming: Pressure { self == .negativeConsumed ? -450 : 450 }

        var tank: Tank {
            switch self {
                case .negativeTankVolume: .cubicFeet(-142, ratedPressure: 2475, with: .air)
                case .negativeRatedPressure: .cubicFeet(142, ratedPressure: -2475, with: .air)
                case .zeroRatedPressure: .cubicFeet(142, ratedPressure: 0, with: .air)
                default: .cubicFeet(142, ratedPressure: 2475, with: .air)
            }
        }

        var expectedError: Error {
            switch self {
                case .negativeDepth: .negative(depth, Self.callSite)
                case .negativeMinutes: .negative(minutes, Self.callSite)
                case .zeroMinutes: .range(.lowerBound(0, 0), Self.callSite)
                case .negativeConsumed: .negative(consuming, Self.callSite)
                case .negativeTankVolume: .tank(.volume(tank.size.volume, tank), Self.callSite)
                case .negativeRatedPressure, .zeroRatedPressure: .tank(.ratedPressure(tank.size.ratedPressure, tank), Self.callSite)
            }
        }

        var localizationValue: String {
            switch self {
                case .negativeDepth: "dive.kit.error.negative.depth"
                case .negativeMinutes: "dive.kit.error.negative.minutes"
                case .zeroMinutes: "dive.kit.error.range.lower.bound"
                case .negativeConsumed: "dive.kit.error.negative.pressure"
                case .negativeTankVolume: "dive.kit.error.tank.size.volume"
                case .negativeRatedPressure, .zeroRatedPressure: "dive.kit.error.tank.size.rated.pressure"
            }
        }
    }

    @Test(.tags(.error), arguments: InvalidRespiratoryMinuteVolumeInput.allCases)
    func respiratoryMinuteVolumeRejectsInvalidInput(input: InvalidRespiratoryMinuteVolumeInput) async throws {
        try await given {
            input
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
                #expect($0.localizationValue == .init(input.localizationValue))
            }
        }
    }
}
