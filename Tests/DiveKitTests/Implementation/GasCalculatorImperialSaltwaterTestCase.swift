import TestUtility
@testable import DiveKit

final class GasCalculatorImperialSaltwaterTestCase: SystemUnderTestCase<GasCalculator> {

    private var physicsCalculator: PhysicsCalculator!

    // MARK: partialPressure(of:at:using:)

    func testPartialPressureValidInput() throws {
        // Given
        let partialPressure = PartialPressure(.oxygen, value: 0.21)
        let depth = 33.0

        // When
        XCTAssertCalculation(try sut.partialPressure(
            of: partialPressure,
            at: depth,
            using: physicsCalculator)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 0.42)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testPartialPressureInvalidInput() throws {
        // Given
        let partialPressure = PartialPressure(.oxygen, value: 0.21)
        let depth = -33.0

        // When
        XCTAssertThrowsError(try sut.partialPressure(
            of: partialPressure,
            at: depth,
            using: physicsCalculator), as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, depth)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.depth")
                XCTAssertEqual(error.callSite, "GasCalculator.partialPressure(of:at:using:)")
            }
    }

    // MARK: partialPressure(of:in:at:using:)

    func testPartialPressureBlendedValidInput() throws {
        // Given
        let gas = Oxygen()
        let blend = Blend<Blended>.air
        let depth = 33.0

        // When
        XCTAssertCalculation(try sut.partialPressure(
            of: gas,
            in: blend,
            at: depth,
            using: physicsCalculator)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 0.42)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testPartialPressureBlendedInvalidInput() throws {
        // Given
        let gas = Oxygen()
        let blend = Blend<Blended>.air
        let depth = -33.0

        // When
        XCTAssertThrowsError(try sut.partialPressure(
            of: gas,
            in: blend,
            at: depth,
            using: physicsCalculator), as: Error<Double>.self) { error in
            // Then
            XCTAssertEqual(error.value, depth)
            XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.depth")
            XCTAssertEqual(error.callSite, "GasCalculator.partialPressure(of:in:at:using:)")
        }
    }

    // MARK: partialPressure(of:blending:at:using:)

    func testPartialPressureUnblendedValidInput() throws {
        // Given
        let gas = Oxygen()
        let blend = try Blend()
            .adding(.oxygen, pressure: 0.21)
            .filling(with: .nitrogen)
        let depth = 33.0

        // When
        XCTAssertCalculation(try sut.partialPressure(
            of: gas,
            blending: blend,
            at: depth,
            using: physicsCalculator)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 0.42)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testPartialPressureUnblendedInvalidInput() throws {
        // Given
        let gas = Oxygen()
        let blend = try Blend()
            .adding(.oxygen, pressure: 0.21)
            .filling(with: .nitrogen)
        let depth = -33.0

        // When
        XCTAssertThrowsError(try sut.partialPressure(
            of: gas,
            blending: blend,
            at: depth,
            using: physicsCalculator), as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, depth)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.depth")
                XCTAssertEqual(error.callSite, "GasCalculator.partialPressure(of:blending:at:using:)")
            }
    }

    func testM() throws {
        let fractionOxygen = 1.4
        let blend = Blend<Blended>.enrichedAir(0.32)

        // When
        XCTAssertCalculation(try sut.maximumOperatingDepth(for: fractionOxygen, in: blend)) { result, configuration in
            // Then
            XCTAssertEqual(result.value, 111.375)
            XCTAssertEqual(result.unit, .feet)
            XCTAssertEqual(configuration, sut.configuration)
        }
    }

    override func createSUT() {
        sut = .init(.imperial, water: .salt)
        physicsCalculator = .init(.imperial, water: .salt)
    }
}
