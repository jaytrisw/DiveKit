import Testing
@testable import DiveKit

@Suite(.tags(.blend))
struct FractionalPressureTestCase {

    @Test
    func initializationStoresValidFractionalPressure() throws {
        // Given
        let gas = Oxygen()

        // When
        let sut = try FractionalPressure(of: gas, fractionalPressure: 0.21)

        // Then
        #expect(sut.gas == gas)
        #expect(sut.value == 0.21)
    }

    @Test(.tags(.error))
    func initializationRejectsNegativeFractionalPressure() throws {
        // Given
        let gas = Oxygen()
        let fractionalPressure = -0.01
        let expectedError: Error = .negative(
            .fractionalPressure(fractionalPressure),
            "FractionalPressure<Oxygen>.init(of:fractionalPressure:)")

        // When / Then
        try expectThrowsError(
            when: try FractionalPressure(of: gas, fractionalPressure: fractionalPressure),
            then: expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.fractional.pressure")
            }
    }

    @Test(.tags(.error))
    func initializationRejectsFractionalPressureGreaterThanOne() throws {
        // Given
        let gas = Oxygen()
        let fractionalPressure = 1.01
        let expectedError: Error = .range(
            .upperBound(fractionalPressure, 1),
            "FractionalPressure<Oxygen>.init(of:fractionalPressure:)")

        // When / Then
        try expectThrowsError(
            when: try FractionalPressure(of: gas, fractionalPressure: fractionalPressure),
            then: expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.range.upper.bound")
            }
    }

    @Test(.tags(.error))
    func negativeErrorMapsUnsafeFractionalPressureToFractionalPressureInput() throws {
        // Given
        let fractionalPressure = -0.01
        let expectedError = Error.negative(
            .fractionalPressure(fractionalPressure),
            "FractionalPressure<Oxygen>.init(of:fractionalPressure:)")

        // When / Then
        try expectThrowsError(
            when: try FractionalPressure(of: .oxygen, fractionalPressure: fractionalPressure),
            then: expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.fractional.pressure")

            }
    }
}
