import Testing
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: equivalentAirDepth(for:with:)

    @Test
    func equivalentAirDepthValidInput() async throws {
        try await given {
            let depth: Depth = 80.0
            let blend = try Blend<Blended>.enrichedAir(0.4)
            return {
                try expectCalculation(
                    self.sut.equivalentAirDepth(for: depth, with: blend)) { result, configuration in
                        #expect(result.value == 52.82278481012658)
                        #expect(result.unit == .feet)
                        #expect(configuration == self.sut.configuration)
                    }
            }
        } when: { operation in
            try operation()
        }
    }

    @Test
    func equivalentAirDepthUnblendedValidInput() async throws {
        try await given {
            let depth: Depth = 80.0
            let blend = try Blend<Unblended>()
                .adding(.oxygen, pressure: 0.4)
                .filling(with: .nitrogen)
            return {
                try expectCalculation(
                    self.sut.equivalentAirDepth(for: depth, with: blend)) { result, configuration in
                        #expect(result.value == 52.82278481012658)
                        #expect(result.unit == .feet)
                        #expect(configuration == self.sut.configuration)
                    }
            }
        } when: { operation in
            try operation()
        }
    }

    @Test(.tags(.error))
    func equivalentAirDepthInvalidDepthInput() async throws {
        try await given {
            let depth: Depth = -80.0
            let blend = try Blend<Blended>.enrichedAir(0.4)
            self.expectedError = .negative(depth, "GasCalculator.equivalentAirDepth(for:with:)")
            return {
                try expectThrowsError(
                    when: self.sut.equivalentAirDepth(for: depth, with: blend),
                    then: self.expectedError) {
                        #expect($0.localizationValue == "dive.kit.error.negative.depth")
                    }
            }
        } when: { operation in
            try operation()
        }
    }

    @Test(.tags(.error))
    func equivalentAirDepthUnblendedInvalidBlendInput() async throws {
        try await given {
            let depth: Depth = 80.0
            let fractionalPressure = 0.4
            let blend = try Blend<Unblended>(.init(of: .oxygen, fractionalPressure: 0.4))
            self.expectedError = .blend(.totalPressure(fractionalPressure, blend), "GasCalculator.equivalentAirDepth(for:with:)")
            return {
                try expectThrowsError(
                    when: self.sut.equivalentAirDepth(for: depth, with: blend),
                    then: self.expectedError) {
                        #expect($0.localizationValue == "dive.kit.error.blend.total.pressure")
                    }
            }
        } when: { operation in
            try operation()
        }
    }
}
