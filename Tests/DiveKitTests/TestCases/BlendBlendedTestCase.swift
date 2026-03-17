import XCTest
@testable @_spi(unsafe) import DiveKit

final class BlendBlendedTestCase: SystemUnderTestCase<Blend<Blended>> {

    func testPartialPressure() throws {
        // Given
        let gas = Oxygen()
        sut = try Blend()
            .filling(with: gas)
            .blend()

        // When
        let result = try sut.partialPressure(of: gas)

        // Then
        XCTAssertEqual(result.fractionalPressure, 1.0)
        XCTAssertEqual(result.gas, gas)
    }

    func testPartialPressureGasNotInBlend() throws {
        // Given
        let gas = Oxygen()
        sut = try Blend()
            .filling(with: .nitrogen)
            .blend()

        // When
        let result = try sut.partialPressure(of: gas)

        // Then
        XCTAssertEqual(result.fractionalPressure, 0)
        XCTAssertEqual(result.gas, gas)
    }

    func testInitializationWithParameterPacks() throws {
        // Given
        let oxygen = Oxygen()
        let oxygenFraction = 1.0

        // When
        sut = try .init(.init(of: oxygen, fractionalPressure: oxygenFraction))

        // Then
        XCTAssertEqual(try sut.partialPressure(of: oxygen).fractionalPressure, oxygenFraction)
        XCTAssertEqual(sut.components().count, 1)
    }

    func testInitializeWithResultBuilder() throws {
        // When
        sut = try .init { () throws(DiveKit.Error) in
            try PartialPressure(of: .oxygen, fractionalPressure: 0.40)

            try PartialPressure(of: .nitrogen, fractionalPressure: 0.60)
        }

        // Then
        XCTAssertEqual(sut.totalPressure, 1.0)
        XCTAssertEqual(sut.components().count, 2)
    }

    func testInitializeWithResultBuilder_consumingUnsafeAPI() throws {
        // Given
        let oxygen = PartialPressure(.oxygen, fractionalPressure: 0.40)
        let nitrogen = PartialPressure(.nitrogen, fractionalPressure: 0.60)

        // When
        sut = .init {
            oxygen

            nitrogen
        }

        // Then
        XCTAssertEqual(sut.totalPressure, 1.0)
        XCTAssertEqual(sut.components().count, 2)
    }
}
