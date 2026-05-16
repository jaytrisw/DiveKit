import Testing
@testable import DiveKit

@Suite
struct RateLocalizationTests {
    @Test func localizedTitle() {
        withTestLocalization(.test) {
            // Given
            let sut = Rate<Pressure>.Unit.perMinute(.psi)

            // When
            let result = sut.localizedTitle

            // Then
            #expect(result == "Pressure Rate")
        }
    }

    @Test func descriptionShort() {
        withTestLocalization(.test) {
            // Given
            let sut = Rate<Pressure>.Unit.perMinute(.psi)

            // When
            let result = sut.localizedDescription(for: .short)

            // Then
            #expect(result == "psi/min")
        }
    }

    @Test func descriptionFull() {
        withTestLocalization(.test) {
            // Given
            let sut = Rate<Volume>.Unit.perMinute(.cubicFeet)

            // When
            let result = sut.localizedDescription(for: .full)

            // Then
            #expect(result == "cubic feet per minute")
        }
    }

    @Test func quantityFull() {
        withTestLocalization(.test) {
            // Given
            let sut = Rate<Pressure>.Unit.perMinute(.psi)

            // When
            let result = sut.localization(for: .quantity(1, .full))

            // Then
            #expect(result == "1 pound per square inch per minute")
        }
    }
}
