import Testing
@testable import DiveKit

@Suite("Atmospheres Absolute", .tags(.atmospheresAbsolute))
struct AtmospheresAbsoluteTests {
    @Test(.tags(.saltWater, .metric), arguments: [
        (depth: 0.0, expected: 1),
        (10, 2),
        (20, 3),
        (30, 4),
        (40, 5),
        (38.5, 4.85)
    ])
    func metricSaltwater(depth: Double, atmospheres: Double) async throws {
        try await given {
            PhysicsCalculator(.metric, water: .salt)
        } when: { sut in
            try sut.atmospheresAbsolute(at: Depth(depth))
        } then: { sut, calculation in
            #expect(calculation.result.value.isApproximately(atmospheres))
            #expect(calculation.result.unit == .atmospheres)
            #expect(calculation.configuration == sut.configuration)
        }
    }

    @Test(.tags(.freshWater, .metric), arguments: [
        (depth: 0.0, expected: 1),
        (10.3, 2),
        (20.6, 3),
        (30.9, 4),
        (41.2, 5),
        (38.5, 4.737864077669903)
    ])
    func metricFreshwater(depth: Double, atmospheres: Double) async throws {
        try await given {
            PhysicsCalculator(.metric, water: .fresh)
        } when: { sut in
            try sut.atmospheresAbsolute(at: Depth(depth))
        } then: { sut, calculation in
            #expect(calculation.result.value.isApproximately(atmospheres))
            #expect(calculation.result.unit == .atmospheres)
            #expect(calculation.configuration == sut.configuration)
        }
    }

    @Test(.tags(.saltWater, .imperial), arguments: [
        (depth: 0.0, expected: 1),
        (33, 2),
        (66, 3),
        (99, 4),
        (132, 5),
        (87, 3.6363636363636362)
    ])
    func imperialSaltwater(depth: Double, atmospheres: Double) async throws {
        try await given {
            PhysicsCalculator(.imperial, water: .salt)
        } when: { sut in
            try sut.atmospheresAbsolute(at: Depth(depth))
        } then: { sut, calculation in
            #expect(calculation.result.value.isApproximately(atmospheres))
            #expect(calculation.result.unit == .atmospheres)
            #expect(calculation.configuration == sut.configuration)
        }
    }

    @Test(.tags(.freshWater, .imperial), arguments: [
        (depth: 0.0, expected: 1),
        (34, 2),
        (68, 3),
        (102, 4),
        (136, 5),
        (87, 3.5588235294117645)
    ])
    func imperialFreshwater(depth: Double, atmospheres: Double) async throws {
        try await given {
            PhysicsCalculator(.imperial, water: .fresh)
        } when: { sut in
            try sut.atmospheresAbsolute(at: Depth(depth))
        } then: { sut, calculation in
            #expect(calculation.result.value.isApproximately(atmospheres))
            #expect(calculation.result.unit == .atmospheres)
            #expect(calculation.configuration == sut.configuration)
        }
    }
}
