import Testing
@testable @_spi(unsafe) import DiveKit

@Suite("Blend Blended", .tags(.blend))
struct BlendBlendedTestCase {

    @Test
    func fraction() throws {
        let gas = Oxygen()
        let sut = try Blend()
            .filling(with: gas)
            .blend()

        let result = try sut.fractionalPressure(of: gas)

        #expect(result.value == 1.0)
        #expect(result.gas == gas)
    }

    @Test
    func fractionGasNotInBlend() throws {
        let gas = Oxygen()
        let sut = try Blend()
            .filling(with: .nitrogen)
            .blend()

        let result = try sut.fractionalPressure(of: gas)

        #expect(result.value == 0)
        #expect(result.gas == gas)
    }

    @Test
    func initializationWithParameterPacks() throws {
        let oxygen = Oxygen()
        let oxygenFraction = 1.0

        let sut = try Blend<Blended>(.init(of: oxygen, fractionalPressure: oxygenFraction))

        let result = try sut.fractionalPressure(of: oxygen)
        #expect(result.value == oxygenFraction)
        #expect(sut.components().count == 1)
    }

    @Test
    func initializeWithResultBuilder() throws {
        let sut = try Blend<Blended> { () throws(DiveKit.Error) in
            try FractionalPressure(of: .oxygen, fractionalPressure: 0.40)

            try FractionalPressure(of: .nitrogen, fractionalPressure: 0.60)
        }

        #expect(sut.totalPressure == 1.0)
        #expect(sut.components().count == 2)
    }

    @Test
    func initializeWithResultBuilder_consumingUnsafeAPI() throws {
        let oxygen = FractionalPressure(.oxygen, fractionalPressure: 0.40)
        let nitrogen = FractionalPressure(.nitrogen, fractionalPressure: 0.60)

        let sut = Blend<Blended> {
            oxygen

            nitrogen
        }

        #expect(sut.totalPressure == 1.0)
        #expect(sut.components().count == 2)
    }
}
