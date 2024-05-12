import XCTest
@testable import DiveKit

final class DepthQuantityTestCase: ThrowingMethodUnderTestCase<Depth.Unit, Quantity, String> {

    func testImperial() throws {
        // Given
        sut = .feet
        mut = quantity(_:)
        data = [
            .init(.init(value: -100, style: .full), output: "-100 feet"),
            .init(.init(value: 0, style: .full), output: "0 feet"),
            .init(.init(value: 0.1, style: .full), output: "0.1 feet"),
            .init(.init(value: 1, style: .full), output: "1 foot"),
            .init(.init(value: 1.001, style: .full), output: "1.001 feet"),
            .init(.init(value: 1.0006, style: .full), output: "1.001 feet"),
            .init(.init(value: 10, style: .full), output: "10 feet"),
            .init(.init(value: 100, style: .full), output: "100 feet")
        ]

        // When
        try data.forEach {
            // Then
            XCTAssertEqual(try mut($0.input), $0.output)
        }
    }

    func quantity(_ quantity: Quantity) -> String {
        sut.localization(for: .quantity(quantity.value, quantity.style))
    }
}

struct Quantity: Equatable {
    let value: Double
    let style: LocalizationStyle
}
