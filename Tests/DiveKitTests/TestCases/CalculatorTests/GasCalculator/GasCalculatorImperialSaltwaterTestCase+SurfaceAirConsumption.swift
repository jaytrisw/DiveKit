import XCTest
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {
    
    // MARK: surfaceAirConsumption(at:for:consuming:using:)
    
    func testSurfaceAirConsumptionConsumingValidInput() throws {
        // Given
        let depth: Depth = 90.0
        let minutes: Minutes = 10.0
        let consuming: Pressure = 600.0
        
        // When
        try XCTAssertCalculation(
            sut.surfaceAirConsumption(
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
        let depth: Depth = -90.0
        let minutes: Minutes = 10.0
        let consuming: Pressure = 600.0
        expectedError = .input(.negative(.depth(depth)), "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)")
        
        // When
        try XCTAssertThrowsError(
            when: sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                consuming: consuming,
                using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.depth")
            }
    }
    
    func testSurfaceAirConsumptionConsumingInvalidMinutesInput() throws {
        // Given
        let depth: Depth = 90.0
        let minutes: Minutes = -10.0
        let consuming: Pressure = 600.0
        expectedError = .input(.negative(.minutes(minutes)), "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)")
        
        // When
        try XCTAssertThrowsError(
            when: sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                consuming: consuming,
                using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.minutes")
            }
    }
    
    func testSurfaceAirConsumptionConsumingInvalidConsumingInput() throws {
        // Given
        let depth: Depth = 90.0
        let minutes: Minutes = 10.0
        let consuming: Pressure = -600.0
        expectedError = .input(.negative(.pressure(consuming)), "GasCalculator.surfaceAirConsumption(at:for:consuming:using:)")
        
        // When
        try XCTAssertThrowsError(
            when:
                sut.surfaceAirConsumption(
                    at: depth,
                    for: minutes,
                    consuming: consuming,
                    using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.pressure")
            }
    }
    
    // MARK: surfaceAirConsumption(at:for:start:end:using:)
    
    func testSurfaceAirConsumptionStartEndValidInput() throws {
        // Given
        let depth: Depth = 90.0
        let minutes: Minutes = 10.0
        let startPressure: Pressure = 3000.0
        let endPressure: Pressure = 2400.0
        
        // When
        try XCTAssertCalculation(
            sut.surfaceAirConsumption(
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
        let depth: Depth = -90.0
        let minutes: Minutes = 10.0
        let startPressure: Pressure = 3000.0
        let endPressure: Pressure = 2400.0
        expectedError = .input(.negative(.depth(depth)), "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
        
        // When
        try XCTAssertThrowsError(
            when: sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.depth")
            }
    }
    
    func testSurfaceAirConsumptionStartEndInvalidTimeInput() throws {
        // Given
        let depth: Depth = 90.0
        let minutes: Minutes = -10.0
        let startPressure: Pressure = 3000.0
        let endPressure: Pressure = 2400.0
        expectedError = .input(.negative(.minutes(minutes)), "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
        
        // When
        try XCTAssertThrowsError(
            when: sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.minutes")
            }
    }
    
    func testSurfaceAirConsumptionStartEndInvalidStartPressureInput() throws {
        // Given
        let depth: Depth = 90.0
        let minutes: Minutes = 10.0
        let startPressure: Pressure = -3000.0
        let endPressure: Pressure = 2400.0
        expectedError = .input(.negative(.pressure(startPressure)), "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
        
        // When
        try XCTAssertThrowsError(
            when: sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.pressure")
            }
    }
    
    func testSurfaceAirConsumptionStartEndInvalidEndPressureInput() throws {
        // Given
        let depth: Depth = 90.0
        let minutes: Minutes = 10.0
        let startPressure: Pressure = 3000.0
        let endPressure: Pressure = -2400.0
        expectedError = .input(.negative(.pressure(endPressure)), "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
        
        // When
        try XCTAssertThrowsError(
            when: sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.pressure")
            }
    }
    
    func testSurfaceAirConsumptionStartEndInvalidCalculatedConsumingPressureInput() throws {
        // Given
        let depth: Depth = 90.0
        let minutes: Minutes = 10.0
        let startPressure: Pressure = 2400.0
        let endPressure: Pressure = 3000.0
        let consumed: Pressure = -600
        expectedError = .input(.negative(.pressure(consumed)), "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)")
        
        // When
        try XCTAssertThrowsError(
            when: sut.surfaceAirConsumption(
                at: depth,
                for: minutes,
                start: startPressure,
                end: endPressure,
                using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.pressure")
            }
    }
    
}
