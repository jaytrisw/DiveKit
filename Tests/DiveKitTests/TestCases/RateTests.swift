import Testing
@testable import DiveKit

@Suite
struct RateTests {
    @Test func initialization() {
        // Given
        let expected: Double = 15

        // When
        let sut = Rate<Pressure>(expected)

        // Then
        #expect(sut.value == expected)
    }

    @Test func equatable() {
        // Given
        let lhs: Rate<Pressure> = 15
        let rhs: Rate<Pressure> = 15

        // When
        let result = lhs == rhs

        // Then
        #expect(result == true)
    }

    @Test func localization() {
        withTestLocalization(.test) {
            // Given
            let sut: Rate<Pressure> = 15

            // When
            let result = sut.localization(for: .perMinute(.psi), style: .short)

            // Then
            #expect(result == "15 psi/min")
        }
    }
}
