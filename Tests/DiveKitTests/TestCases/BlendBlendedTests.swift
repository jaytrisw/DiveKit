import Testing
@testable import DiveKit
import DiveKitTestSupport

@Suite("Blend Blended", .tags(.blend))
struct BlendBlendedTests {

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

    @Test
    func totalPressureIgnoresInsertionOrderOfSameTypeGases() {
        let fractions = [0.1, 0.2, 0.3, 0.0123456789, 0.07, 0.31]
        let expected = fractions.sorted().reduce(0, +)
        let (gas0, gas1, gas2, gas3, gas4, gas5) = (
            Mixture(id: 0), Mixture(id: 1), Mixture(id: 2),
            Mixture(id: 3), Mixture(id: 4), Mixture(id: 5))

        let forward = Blend<Unblended>(
            (gas0, fractions[0]), (gas1, fractions[1]), (gas2, fractions[2]),
            (gas3, fractions[3]), (gas4, fractions[4]), (gas5, fractions[5]))
        let reversed = Blend<Unblended>(
            (gas5, fractions[5]), (gas4, fractions[4]), (gas3, fractions[3]),
            (gas2, fractions[2]), (gas1, fractions[1]), (gas0, fractions[0]))
        let shuffled = Blend<Unblended>(
            (gas2, fractions[2]), (gas5, fractions[5]), (gas0, fractions[0]),
            (gas4, fractions[4]), (gas1, fractions[1]), (gas3, fractions[3]))

        #expect(forward.totalPressure == expected)
        #expect(reversed.totalPressure == expected)
        #expect(shuffled.totalPressure == expected)
    }
}

private struct Mixture: GasRepresentable {
    let id: Int

    var metabolism: Metabolism { .inert }
    var narcoticPotency: NarcoticPotency { .relative(0) }
}
