import Testing
@testable import DiveKit

@Suite(.tags(.localization))
struct VolumeLocalizationTests {
    @Test func localizedTitleDImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Volume.Unit.cubicFeet

            // When
            let result = sut.localizedTitle

            // Then
            #expect(result == "Volume")
        }
    }

    @Test func localizedTitleMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Volume.Unit.liters

            // When
            let result = sut.localizedTitle

            // Then
            #expect(result == "Volume")
        }
    }

    @Test func descriptionShortImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Volume.Unit.cubicFeet

            // When
            let result = sut.localizedDescription(for: .short)

            // Then
            #expect(result == "cu ft")
        }
    }

    @Test func descriptionShortMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Volume.Unit.liters

            // When
            let result = sut.localizedDescription(for: .short)

            // Then
            #expect(result == "l")
        }
    }

    @Test func descriptionFullImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Volume.Unit.cubicFeet

            // When
            let result = sut.localizedDescription(for: .full)

            // Then
            #expect(result == "cubic feet")
        }
    }

    @Test func descriptionFullMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Volume.Unit.liters

            // When
            let result = sut.localizedDescription(for: .full)

            // Then
            #expect(result == "liters")
        }
    }

    @Test func quantityShortImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Volume.Unit.cubicFeet

            // When
            let result = sut.localization(for: .quantity(.zero, .short))

            // Then
            #expect(result == "0 cu ft")
        }
    }

    @Test func quantityShortMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Volume.Unit.liters

            // When
            let result = sut.localization(for: .quantity(.zero, .short))

            // Then
            #expect(result == "0 l")
        }
    }

    @Test func quantityFullImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Volume.Unit.cubicFeet

            // When
            let result = sut.localization(for: .quantity(.zero, .full))

            // Then
            #expect(result == "0 cubic feet")
        }
    }

    @Test func quantityFullMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Volume.Unit.liters

            // When
            let result = sut.localization(for: .quantity(.zero, .full))

            // Then
            #expect(result == "0 liters")
        }
    }

    @Test func oneQuantityFullImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Volume.Unit.cubicFeet

            // When
            let result = sut.localization(for: .quantity(1, .full))

            // Then
            #expect(result == "1 cubic foot")
        }
    }

    @Test func oneQuantityFullMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Volume.Unit.liters

            // When
            let result = sut.localization(for: .quantity(1, .full))

            // Then
            #expect(result == "1 liter")
        }
    }
}
