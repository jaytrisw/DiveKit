import Testing
@testable import DiveKit

@Suite(.tags(.blend))
struct FractionalPressureTests {

    @Test
    func initializationStoresValidFractionalPressure() async throws {
        try await given {
            Oxygen()
        } when: { gas in
            try FractionalPressure(of: gas, fractionalPressure: 0.21)
        } then: { gas, sut in
            #expect(sut.gas == gas)
            #expect(sut.value == 0.21)
        }
    }

    @Test(.tags(.error))
    func initializationRejectsNegativeFractionalPressure() async throws {
        try await given {
            let fractionalPressure = -0.01
            let expectedError: Error = .negative(
                .fractionalPressure(fractionalPressure),
                "FractionalPressure<Oxygen>.init(of:fractionalPressure:)")

            return (gas: Oxygen(), fractionalPressure: fractionalPressure, expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try FractionalPressure(of: input.gas, fractionalPressure: input.fractionalPressure),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.fractional.pressure")
            }
        }
    }

    @Test(.tags(.error))
    func initializationRejectsFractionalPressureGreaterThanOne() async throws {
        try await given {
            let fractionalPressure = 1.01
            let expectedError: Error = .range(
                .upperBound(fractionalPressure, 1),
                "FractionalPressure<Oxygen>.init(of:fractionalPressure:)")

            return (gas: Oxygen(), fractionalPressure: fractionalPressure, expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try FractionalPressure(of: input.gas, fractionalPressure: input.fractionalPressure),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test(.tags(.error))
    func negativeErrorMapsUnsafeFractionalPressureToFractionalPressureInput() async throws {
        try await given {
            let fractionalPressure = -0.01
            let expectedError = Error.negative(
                .fractionalPressure(fractionalPressure),
                "FractionalPressure<Oxygen>.init(of:fractionalPressure:)")

            return (fractionalPressure: fractionalPressure, expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try FractionalPressure(of: .oxygen, fractionalPressure: input.fractionalPressure),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.fractional.pressure")
            }
        }
    }
}
