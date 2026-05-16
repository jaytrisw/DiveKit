import Testing
@testable import DiveKit

@Suite(.tags(.localization))
struct DepthLocalizationTests {
    @Test func localizedTitleDImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Depth.Unit.feet

            // When
            let result = sut.localizedTitle

            // Then
            #expect(result == "Depth")
        }
    }

    @Test func localizedTitleMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Depth.Unit.meters

            // When
            let result = sut.localizedTitle

            // Then
            #expect(result == "Depth")
        }
    }

    @Test func descriptionShortImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Depth.Unit.feet

            // When
            let result = sut.localizedDescription(for: .short)

            // Then
            #expect(result == "ft")
        }
    }

    @Test func descriptionShortMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Depth.Unit.meters

            // When
            let result = sut.localizedDescription(for: .short)

            // Then
            #expect(result == "m")
        }
    }

    @Test func descriptionFullImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Depth.Unit.feet

            // When
            let result = sut.localizedDescription(for: .full)

            // Then
            #expect(result == "feet")
        }
    }

    @Test func descriptionFullMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Depth.Unit.meters

            // When
            let result = sut.localizedDescription(for: .full)

            // Then
            #expect(result == "meters")
        }
    }

    @Test func quantityShortImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Depth.Unit.feet

            // When
            let result = sut.localization(for: .quantity(.zero, .short))

            // Then
            #expect(result == "0 ft")
        }
    }

    @Test func quantityShortMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Depth.Unit.meters

            // When
            let result = sut.localization(for: .quantity(.zero, .short))

            // Then
            #expect(result == "0 m")
        }
    }

    @Test func quantityFullImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Depth.Unit.feet

            // When
            let result = sut.localization(for: .quantity(.zero, .full))

            // Then
            #expect(result == "0 feet")
        }
    }

    @Test func quantityFullMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Depth.Unit.meters

            // When
            let result = sut.localization(for: .quantity(.zero, .full))

            // Then
            #expect(result == "0 meters")
        }
    }

    @Test func oneQuantityFullImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Depth.Unit.feet

            // When
            let result = sut.localization(for: .quantity(1, .full))

            // Then
            #expect(result == "1 foot")
        }
    }

    @Test func oneQuantityFullMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Depth.Unit.meters

            // When
            let result = sut.localization(for: .quantity(1, .full))

            // Then
            #expect(result == "1 meter")
        }
    }
}
