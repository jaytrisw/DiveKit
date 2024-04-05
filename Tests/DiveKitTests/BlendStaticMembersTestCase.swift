import XCTest
@testable import DiveKit

final class BlendStaticMembersTestCase: SystemUnderTestCase<Blend<Blended>> {
    func testAir() {
        // Given
        sut = .air

        // When
        let oxygen = sut.partialPressure(of: .oxygen)
        let nitrogen = sut.partialPressure(of: .nitrogen)
        let trace = sut.partialPressure(of: .trace)

        // Then
        XCTAssertEqual(oxygen.value, 0.209)
        XCTAssertEqual(oxygen.gas, .oxygen)
        XCTAssertEqual(nitrogen.value, 0.79)
        XCTAssertEqual(nitrogen.gas, .nitrogen)
        XCTAssertEqual(trace.value, 0.001)
        XCTAssertEqual(trace.gas, .trace)
        XCTAssertEqual(sut.totalPressure, 1.0)
        XCTAssertEqual(sut.storage.count, 3)
    }

    func testEnrichedAir() {
        // Given
        let oxygenFraction = 0.32
        sut = .enrichedAir(oxygenFraction)

        // When
        let oxygen = sut.partialPressure(of: .oxygen)
        let nitrogen = sut.partialPressure(of: .nitrogen)

        // Then
        XCTAssertEqual(oxygen.value, oxygenFraction)
        XCTAssertEqual(oxygen.gas, .oxygen)
        XCTAssertEqual(nitrogen.value, 0.68, accuracy: 0.1)
        XCTAssertEqual(nitrogen.gas, .nitrogen)
        XCTAssertEqual(sut.totalPressure, 1.0)
        XCTAssertEqual(sut.storage.count, 2)
    }
}
