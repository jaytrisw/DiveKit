import Testing
@testable @_spi(unsafe) import DiveKit

final class BlendBlendedTestCase: SystemUnderTestCase<Blend<Blended>> {

    @Test
    func testFraction() throws {
        // Given
        let gas = Oxygen()
        sut = try Blend()
            .filling(with: gas)
            .blend()

        // When
        let result = try sut.fractionalPressure(of: gas)

        // Then
        #expect(result.value == 1.0)
        #expect(result.gas == gas)
    }

    @Test
    func testFractionGasNotInBlend() throws {
        // Given
        let gas = Oxygen()
        sut = try Blend()
            .filling(with: .nitrogen)
            .blend()

        // When
        let result = try sut.fractionalPressure(of: gas)

        // Then
        #expect(result.value == 0)
        #expect(result.gas == gas)
    }

    @Test
    func testInitializationWithParameterPacks() throws {
        // Given
        let oxygen = Oxygen()
        let oxygenFraction = 1.0

        // When
        sut = try .init(.init(of: oxygen, fractionalPressure: oxygenFraction))

        // Then
        try #expect(try sut.fractionalPressure(of: oxygen).value == oxygenFraction)
        #expect(sut.components().count == 1)
    }

    @Test
    func testInitializeWithResultBuilder() throws {
        // When
        sut = try .init { () throws(DiveKit.Error) in
            try FractionalPressure(of: .oxygen, fractionalPressure: 0.40)

            try FractionalPressure(of: .nitrogen, fractionalPressure: 0.60)
        }

        // Then
        #expect(sut.totalPressure == 1.0)
        #expect(sut.components().count == 2)
    }

    @Test
    func testInitializeWithResultBuilder_consumingUnsafeAPI() throws {
        // Given
        let oxygen = FractionalPressure(.oxygen, fractionalPressure: 0.40)
        let nitrogen = FractionalPressure(.nitrogen, fractionalPressure: 0.60)

        // When
        sut = .init {
            oxygen

            nitrogen
        }

        // Then
        #expect(sut.totalPressure == 1.0)
        #expect(sut.components().count == 2)
    }
}
