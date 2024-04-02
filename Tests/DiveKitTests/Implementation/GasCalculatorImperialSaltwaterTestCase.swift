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
        XCTAssertThrowsError(
            try sut.partialPressure(
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

    // MARK: maximumOperatingDepth(for:in:)

    func testMaximumOperatingDepthValidInput() throws {
        let fractionOxygen = 1.4
        let blend = Blend<Blended>.enrichedAir(0.32)

        // When
        XCTAssertCalculation(
            try sut.maximumOperatingDepth(for: fractionOxygen, in: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 111.375)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testMaximumOperatingDepthInvalidInput() throws {
        let fractionOxygen = -1.4
        let blend = Blend<Blended>.enrichedAir(0.32)

        // When
        XCTAssertThrowsError(
            try sut.maximumOperatingDepth(for: fractionOxygen, in: blend),
            as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, fractionOxygen)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.fraction.oxygen")
                XCTAssertEqual(error.callSite, "GasCalculator.maximumOperatingDepth(for:in:)")
            }
    }

    // MARK: surfaceAirConsumption(at:for:consuming:using:)

    func testSurfaceAirConsumptionConsumingValidInput() throws {
        // Given
        let depth = 90.0
        let minutes = 10.0
        let consuming = 600.0

        // When
        XCTAssertCalculation(
            try sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                consuming: consuming,
                using: physicsCalculator)) { result, configuration in
                    // Then
                    XCTAssertEqual(result.value, 16.097560975609756)
                    XCTAssertEqual(result.unit, .psi)
                    XCTAssertEqual(configuration, sut.configuration)
                }
    }

    func testSurfaceAirConsumptionConsumingInvalidDepthInput() throws {
        // Given
        let depth = -90.0
        let minutes = 10.0
        let consuming = 600.0

        // When
        XCTAssertThrowsError(
            try sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                consuming: consuming,
                using: physicsCalculator),
            as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, depth)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.depth")
                XCTAssertEqual(error.callSite, "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)")
                }
    }

    func testSurfaceAirConsumptionConsumingInvalidMinutesInput() throws {
        // Given
        let depth = 90.0
        let minutes = -10.0
        let consuming = 600.0

        // When
        XCTAssertThrowsError(
            try sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                consuming: consuming,
                using: physicsCalculator),
            as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, minutes)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.time")
                XCTAssertEqual(error.callSite, "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)")
            }
    }

    func testSurfaceAirConsumptionConsumingInvalidConsumingInput() throws {
        // Given
        let depth = 90.0
        let minutes = 10.0
        let consuming = -600.0

        // When
        XCTAssertThrowsError(
            try sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                consuming: consuming,
                using: physicsCalculator),
            as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, consuming)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.consumed")
                XCTAssertEqual(error.callSite, "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)")
            }
    }

    // MARK: surfaceAirConsumption(at:for:start:end:using:)

    func testSurfaceAirConsumptionStartEndValidInput() throws {
        // Given
        let depth = 90.0
        let minutes = 10.0
        let startPressure = 3000.0
        let endPressure = 2400.0

        // When
        XCTAssertCalculation(
            try sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator)) { result, configuration in
                    // Then
                    XCTAssertEqual(result.value, 16.097560975609756)
                    XCTAssertEqual(result.unit, .psi)
                    XCTAssertEqual(configuration, sut.configuration)
                }
    }

    func testSurfaceAirConsumptionStartEndInvalidDepthInput() throws {
        // Given
        let depth = -90.0
        let minutes = 10.0
        let startPressure = 3000.0
        let endPressure = 2400.0

        // When
        XCTAssertThrowsError(
            try sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator),
            as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, depth)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.depth")
                XCTAssertEqual(error.callSite, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
            }
    }

    func testSurfaceAirConsumptionStartEndInvalidTimeInput() throws {
        // Given
        let depth = 90.0
        let minutes = -10.0
        let startPressure = 3000.0
        let endPressure = 2400.0

        // When
        XCTAssertThrowsError(
            try sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator),
            as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, minutes)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.time")
                XCTAssertEqual(error.callSite, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
            }
    }

    func testSurfaceAirConsumptionStartEndInvalidStartPressureInput() throws {
        // Given
        let depth = 90.0
        let minutes = 10.0
        let startPressure = -3000.0
        let endPressure = 2400.0

        // When
        XCTAssertThrowsError(
            try sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator),
            as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, startPressure)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.start.pressure")
                XCTAssertEqual(error.callSite, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
            }
    }

    func testSurfaceAirConsumptionStartEndInvalidEndPressureInput() throws {
        // Given
        let depth = 90.0
        let minutes = 10.0
        let startPressure = 3000.0
        let endPressure = -2400.0

        // When
        XCTAssertThrowsError(
            try sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator),
            as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, endPressure)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.end.pressure")
                XCTAssertEqual(error.callSite, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
            }
    }

    func testSurfaceAirConsumptionStartEndInvalidCalculatedConsumingPressureInput() throws {
        // Given
        let depth = 90.0
        let minutes = 10.0
        let startPressure = 2400.0
        let endPressure = 3000.0

        // When
        XCTAssertThrowsError(
            try sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator),
            as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, startPressure - endPressure)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.consumed")
                XCTAssertEqual(error.callSite, "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
            }
    }

    override func createSUT() {
        sut = .init(.imperial, water: .salt)
        physicsCalculator = .init(.imperial, water: .salt)
    }
}
