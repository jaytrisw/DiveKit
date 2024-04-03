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
                XCTAssertEqual(result.value, 0.418)
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

    func testPartialPressureUnblendedInvalidBlendInput() throws {
        // Given
        let gas = Oxygen()
        let blend = try Blend()
            .adding(.oxygen, pressure: 0.21)
        let depth = 33.0

        // When
        XCTAssertThrowsError(
            try sut.partialPressure(
                of: gas,
                blending: blend,
                at: depth,
                using: physicsCalculator), 
            as: Error<Blend>.self) { error in
                    // Then
                    XCTAssertEqual(error.value, blend)
                    XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.dive.kit.blend.total.pressure")
                    XCTAssertEqual(error.callSite, "GasCalculator.partialPressure(of:blending:at:using:)")
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

    // MARK: respiratoryMinuteVolume(at:for:consuming:with:using:)

    func testRespiratoryMinuteVolumeValidInput() {
        // Given
        let depth = 40.0
        let minutes = 15.0
        let consuming = 450.0
        let tank = Tank.cubicFeet(142, ratedPressure: 2475, with: .air)

        // When
        XCTAssertCalculation(
            try sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator)) { result, configuration in
                    // Then
                    XCTAssertEqual(result.value, 0.778082191780822)
                    XCTAssertEqual(result.unit, .cubicFeet)
                    XCTAssertEqual(configuration, sut.configuration)
                }
    }

    func testRespiratoryMinuteVolumeInvalidDepthInput() {
        // Given
        let depth = -40.0
        let minutes = 15.0
        let consuming = 450.0
        let tank = Tank.cubicFeet(142, ratedPressure: 2475, with: .air)

        // When
        XCTAssertThrowsError(
            try sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, depth)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.depth")
                XCTAssertEqual(error.callSite, "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            }
    }

    func testRespiratoryMinuteVolumeInvalidMinutesInput() {
        // Given
        let depth = 40.0
        let minutes = -15.0
        let consuming = 450.0
        let tank = Tank.cubicFeet(142, ratedPressure: 2475, with: .air)

        // When
        XCTAssertThrowsError(
            try sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, minutes)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.time")
                XCTAssertEqual(error.callSite, "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            }
    }

    func testRespiratoryMinuteVolumeInvalidConsumedInput() {
        // Given
        let depth = 40.0
        let minutes = 15.0
        let consuming = -450.0
        let tank = Tank.cubicFeet(142, ratedPressure: 2475, with: .air)

        // When
        XCTAssertThrowsError(
            try sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, consuming)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.consumed")
                XCTAssertEqual(error.callSite, "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            }
    }

    func testRespiratoryMinuteVolumeInvalidTankVolumeInput() {
        // Given
        let depth = 40.0
        let minutes = 15.0
        let consuming = 450.0
        let tank = Tank.cubicFeet(-142, ratedPressure: 2475, with: .air)

        // When
        XCTAssertThrowsError(
            try sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            as: Error<Tank>.self) { error in
                // Then
                XCTAssertEqual(error.value, tank)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.invalid.tank")
                XCTAssertEqual(error.callSite, "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            }
    }

    func testRespiratoryMinuteVolumeInvalidTankRatedPressureInput() {
        // Given
        let depth = 40.0
        let minutes = 15.0
        let consuming = 450.0
        let tank = Tank.cubicFeet(142, ratedPressure: -2475, with: .air)

        // When
        XCTAssertThrowsError(
            try sut.respiratoryMinuteVolume(
                at: depth,
                for: minutes,
                consuming: consuming,
                with: tank,
                using: physicsCalculator),
            as: Error<Tank>.self) { error in
                // Then
                XCTAssertEqual(error.value, tank)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.invalid.tank")
                XCTAssertEqual(error.callSite, "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)")
            }
    }

    // MARK: equivalentAirDepth(for:with:)

    func testEquivalentAirDepthValidInput() {
        // Given
        let depth = 80.0
        let blend = Blend<Blended>.enrichedAir(0.4)

        // When
        XCTAssertCalculation(
            try sut.equivalentAirDepth(for: depth, with: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 52.82278481012658)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testEquivalentAirDepthUnblendedValidInput() throws {
        // Given
        let depth = 80.0
        let blend = try Blend<Unblended>()
            .adding(.oxygen, pressure: 0.4)
            .filling(with: .nitrogen)

        // When
        XCTAssertCalculation(
            try sut.equivalentAirDepth(for: depth, with: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 52.82278481012658)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testEquivalentAirDepthInvalidDepthInput() {
        // Given
        let depth = -80.0
        let blend = Blend<Blended>.enrichedAir(0.4)

        // When
        XCTAssertThrowsError(
            try sut.equivalentAirDepth(
                for: depth,
                with: blend),
            as: Error<Double>.self) { error in
                // Then
                XCTAssertEqual(error.value, depth)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.depth")
                XCTAssertEqual(error.callSite, "GasCalculator.equivalentAirDepth(for:with:)")
            }
    }

    func testEquivalentAirDepthUnblendedInvalidBlendInput() throws {
        // Given
        let depth = 80.0
        let blend = try Blend<Unblended>()
            .adding(.oxygen, pressure: 0.4)

        // When
        XCTAssertThrowsError(
            try sut.equivalentAirDepth(
                for: depth,
                with: blend),
            as: Error<Blend>.self) { error in
                // Then
                XCTAssertEqual(error.value, blend)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.dive.kit.blend.total.pressure")
                XCTAssertEqual(error.callSite, "GasCalculator.equivalentAirDepth(for:with:)")
            }
    }

    override func createSUT() {
        sut = .init(.imperial, water: .salt)
        physicsCalculator = .init(.imperial, water: .salt)
    }
}
