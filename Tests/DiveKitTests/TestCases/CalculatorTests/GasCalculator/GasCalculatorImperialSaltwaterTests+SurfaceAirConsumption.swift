import Testing
@testable import DiveKit
import DiveKitTestSupport

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
                // (600 psi / 10 min) / (1 + 90 / 33) = 1980 / 123 = 16.097560975609756… psi/min.
                #expect(result.value.isApproximately(16.097560975609756))
                #expect(result.unit == .perMinute(.psi))
                #expect(configuration == self.sut.configuration)
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
                // (600 psi / 10 min) / (1 + 90 / 33) = 1980 / 123 = 16.097560975609756… psi/min.
                #expect(result.value.isApproximately(16.097560975609756))
                #expect(result.unit == .perMinute(.psi))
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    /// One invalid argument per case, through either overload. The others are
    /// the valid inputs of the happy-path tests: 90 ft, 10 minutes, and 600 psi
    /// consumed or 3000 to 2400 psi.
    enum InvalidSurfaceAirConsumptionInput: CaseIterable, Sendable {
        case consumingNegativeDepth
        case consumingNegativeMinutes
        case consumingZeroMinutes
        case consumingNegativePressure
        case startEndNegativeDepth
        case startEndNegativeMinutes
        case startEndNegativeStart
        case startEndNegativeEnd
        case startEndNegativeConsumed

        var depth: Depth { self == .consumingNegativeDepth || self == .startEndNegativeDepth ? -90 : 90 }
        var minutes: Minutes {
            switch self {
                case .consumingNegativeMinutes, .startEndNegativeMinutes: -10
                case .consumingZeroMinutes: 0
                default: 10
            }
        }
        var consuming: Pressure { self == .consumingNegativePressure ? -600 : 600 }
        var start: Pressure {
            switch self {
                case .startEndNegativeStart: -3000
                case .startEndNegativeConsumed: 2400
                default: 3000
            }
        }
        var end: Pressure {
            switch self {
                case .startEndNegativeEnd: -2400
                case .startEndNegativeConsumed: 3000
                default: 2400
            }
        }

        var usesStartAndEnd: Bool {
            switch self {
                case .consumingNegativeDepth, .consumingNegativeMinutes, .consumingZeroMinutes, .consumingNegativePressure: false
                default: true
            }
        }

        var callSite: CallSite {
            usesStartAndEnd
                ? "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)"
                : "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)"
        }

        var expectedError: Error {
            switch self {
                case .consumingNegativeDepth, .startEndNegativeDepth: .negative(depth, callSite)
                case .consumingNegativeMinutes, .startEndNegativeMinutes: .negative(minutes, callSite)
                case .consumingZeroMinutes: .range(.lowerBound(0, 0), callSite)
                case .consumingNegativePressure: .negative(consuming, callSite)
                case .startEndNegativeStart: .negative(start, callSite)
                case .startEndNegativeEnd: .negative(end, callSite)
                case .startEndNegativeConsumed: .negative(Pressure(-600), callSite)
            }
        }

        var localizationValue: String {
            switch self {
                case .consumingNegativeDepth, .startEndNegativeDepth: "dive.kit.error.negative.depth"
                case .consumingNegativeMinutes, .startEndNegativeMinutes: "dive.kit.error.negative.minutes"
                case .consumingZeroMinutes: "dive.kit.error.range.lower.bound"
                default: "dive.kit.error.negative.pressure"
            }
        }

        func run(on sut: GasCalculator, using physicsCalculator: PhysicsCalculator) throws {
            _ = usesStartAndEnd
                ? try sut.surfaceAirConsumption(at: depth, for: minutes, start: start, end: end, using: physicsCalculator)
                : try sut.surfaceAirConsumption(at: depth, for: minutes, consuming: consuming, using: physicsCalculator)
        }
    }

    @Test(.tags(.error), arguments: InvalidSurfaceAirConsumptionInput.allCases)
    func surfaceAirConsumptionRejectsInvalidInput(input: InvalidSurfaceAirConsumptionInput) async throws {
        try await given {
            input
        } when: { input in
            Result { try input.run(on: self.sut, using: self.physicsCalculator) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == .init(input.localizationValue))
            }
        }
    }
}
