import Testing
@testable import DiveKit

@Suite(.tags(.localization))
struct PressureLocalizationTests {
    @Test func localizedTitleDImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Pressure.Unit.psi

            // When
            let result = sut.localizedTitle

            // Then
            #expect(result == "Pressure")
        }
    }

    @Test func localizedTitleMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Pressure.Unit.bar

            // When
            let result = sut.localizedTitle

            // Then
            #expect(result == "Pressure")
        }
    }

    @Test func localizedTitleAtmospheres() {
        withTestLocalization(.test) {
            // Given
            let sut = Pressure.Unit.atmospheres

            // When
            let result = sut.localizedTitle

            // Then
            #expect(result == "Pressure")
        }
    }

    @Test func descriptionShortImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Pressure.Unit.psi

            // When
            let result = sut.localizedDescription(for: .short)

            // Then
            #expect(result == "psi")
        }
    }

    @Test func descriptionShortMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Pressure.Unit.bar

            // When
            let result = sut.localizedDescription(for: .short)

            // Then
            #expect(result == "bar")
        }
    }

    @Test func descriptionShortAtmospheres() {
        withTestLocalization(.test) {
            // Given
            let sut = Pressure.Unit.atmospheres

            // When
            let result = sut.localizedDescription(for: .short)

            // Then
            #expect(result == "atm")
        }
    }

    @Test func descriptionFullImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Pressure.Unit.psi

            // When
            let result = sut.localizedDescription(for: .full)

            // Then
            #expect(result == "pounds per square inch")
        }
    }

    @Test func descriptionFullMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Pressure.Unit.bar

            // When
            let result = sut.localizedDescription(for: .full)

            // Then
            #expect(result == "bar")
        }
    }

    @Test func descriptionFullAtmospheres() {
        withTestLocalization(.test) {
            // Given
            let sut = Pressure.Unit.atmospheres

            // When
            let result = sut.localizedDescription(for: .full)

            // Then
            #expect(result == "atmospheres")
        }
    }

    @Test func quantityShortImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Pressure.Unit.psi

            // When
            let result = sut.localization(for: .quantity(.zero, .short))

            // Then
            #expect(result == "0 psi")
        }
    }

    @Test func quantityShortMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Pressure.Unit.bar

            // When
            let result = sut.localization(for: .quantity(.zero, .short))

            // Then
            #expect(result == "0 bar")
        }
    }

    @Test func quantityShortAtmospheres() {
        withTestLocalization(.test) {
            // Given
            let sut = Pressure.Unit.atmospheres

            // When
            let result = sut.localization(for: .quantity(.zero, .short))

            // Then
            #expect(result == "0 atm")
        }
    }

    @Test func quantityFullImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Pressure.Unit.psi

            // When
            let result = sut.localization(for: .quantity(.zero, .full))

            // Then
            #expect(result == "0 pounds per square inch")
        }
    }

    @Test func quantityFullMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Pressure.Unit.bar

            // When
            let result = sut.localization(for: .quantity(.zero, .full))

            // Then
            #expect(result == "0 bar")
        }
    }

    @Test func quantityFullAtmospheres() {
        withTestLocalization(.test) {
            // Given
            let sut = Pressure.Unit.atmospheres

            // When
            let result = sut.localization(for: .quantity(.zero, .full))

            // Then
            #expect(result == "0 atmospheres")
        }
    }

    @Test func oneQuantityFullImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Pressure.Unit.psi

            // When
            let result = sut.localization(for: .quantity(1, .full))

            // Then
            #expect(result == "1 pound per square inch")
        }
    }

    @Test func oneQuantityFullMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Pressure.Unit.bar

            // When
            let result = sut.localization(for: .quantity(1, .full))

            // Then
            #expect(result == "1 bar")
        }
    }

    @Test func oneQuantityFullAtmospheres() {
        withTestLocalization(.test) {
            // Given
            let sut = Pressure.Unit.atmospheres

            // When
            let result = sut.localization(for: .quantity(1, .full))

            // Then
            #expect(result == "1 atmosphere")
        }
    }
}
