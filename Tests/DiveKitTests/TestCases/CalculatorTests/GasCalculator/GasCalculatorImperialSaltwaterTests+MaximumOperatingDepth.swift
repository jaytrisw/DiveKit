import Testing
@testable import DiveKit
import DiveKitTestSupport

extension GasCalculatorImperialSaltwaterTests {

    // MARK: maximumOperatingDepth(for:in:)

    /// MOD = (ppO₂ / fO₂ − 1) × 33 ft per atmosphere (the U.S. Navy and NOAA
    /// salt-water formula). Expected depths are the exact decimal results,
    /// such as (1.4 / 0.34 − 1) × 33 = 102.8823529411764705… ft; 0.21 is air.
    @Test(arguments: [
        (partialPressure: 1.4, oxygen: 0.28, feet: 132.0),
        (1.4, 0.30, 121.0),
        (1.4, 0.32, 111.375),
        (1.4, 0.34, 102.88235294117647),
        (1.4, 0.36, 95.33333333333333),
        (1.4, 0.40, 82.5),
        (1.4, 0.21, 187.0),
        (1.6, 0.28, 155.57142857142858),
        (1.6, 0.30, 143.0),
        (1.6, 0.32, 132.0),
        (1.6, 0.34, 122.29411764705883),
        (1.6, 0.36, 113.66666666666667),
        (1.6, 0.40, 99.0),
        (1.6, 0.21, 218.42857142857142)])
    func maximumOperatingDepth(partialPressure: Double, oxygen: Double, feet: Double) async throws {
        try await given {
            (partialPressure: PartialPressure<Oxygen>(partialPressure),
             blend: oxygen == 0.21 ? Blend<Blended>.air : try Blend<Blended>.enrichedAir(oxygen))
        } when: { input in
            try self.sut.maximumOperatingDepth(for: input.partialPressure, in: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(result.value.isApproximately(feet))
                #expect(result.unit == .feet)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    /// (0.7 / 0.8 - 1) * 33 = -0.125 * 33 = -4.125 ft: the blend exceeds the limit at the surface.
    @Test
    func maximumOperatingDepthIsNegativeWhenOxygenFractionExceedsLimit() async throws {
        try await given {
            let partialPressure: PartialPressure<Oxygen> = 0.7
            let blend = try Blend<Blended>.enrichedAir(0.80)
            return (partialPressure: partialPressure, blend: blend)
        } when: { input in
            try self.sut.maximumOperatingDepth(for: input.partialPressure, in: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(result.value.isApproximately(-4.125))
                #expect(result.unit == .feet)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test(.tags(.error))
    func maximumOperatingDepthRejectsNegativeOxygenPartialPressure() async throws {
        try await given {
            let partialPressure: PartialPressure<Oxygen> = -1.4
            let blend = try Blend<Blended>.enrichedAir(0.32)
            let expectedError: Error = .negative(partialPressure, "GasCalculator.maximumOperatingDepth(for:in:)")

            return (partialPressure: partialPressure, blend: blend, expectedError: expectedError)
        } when: { input in
            Result { try self.sut.maximumOperatingDepth(for: input.partialPressure, in: input.blend) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.partial.pressure")
            }
        }
    }

    @Test(.tags(.error))
    func maximumOperatingDepthRejectsBlendWithZeroOxygen() async throws {
        try await given {
            let partialPressure: PartialPressure<Oxygen> = 1.4

            let blend = try Blend<Blended> { () throws(DiveKit.Error) in
                try FractionalPressure(of: .oxygen, fractionalPressure: 0.0)
                try FractionalPressure(of: .nitrogen, fractionalPressure: 1.0)
            }

            let expectedError: Error = .range(
                .lowerBound(0, 0),
                "GasCalculator.maximumOperatingDepth(for:in:)")
            return (partialPressure: partialPressure, blend: blend, expectedError: expectedError)
        } when: { input in
            Result { try self.sut.maximumOperatingDepth(for: input.partialPressure, in: input.blend) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.lower.bound")
            }
        }
    }

    @Test(.tags(.error))
    func maximumOperatingDepthRejectsZeroOxygenPartialPressure() async throws {
        try await given {
            let partialPressure: PartialPressure<Oxygen> = 0
            let blend = try Blend<Blended>.enrichedAir(0.32)

            let expectedError: Error = .range(
                .lowerBound(0, 0),
                "GasCalculator.maximumOperatingDepth(for:in:)")
            return (partialPressure: partialPressure, blend: blend, expectedError: expectedError)
        } when: { input in
            Result { try self.sut.maximumOperatingDepth(for: input.partialPressure, in: input.blend) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.lower.bound")
            }
        }
    }
}
