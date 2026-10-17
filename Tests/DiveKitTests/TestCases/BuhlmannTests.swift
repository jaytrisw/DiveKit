import Testing
@_spi(Experimental) @testable import DiveKit

@Suite("Bühlmann", .tags(.technicalDiving, .buhlmann))
struct BuhlmannTests {
    @Test
    func zhl16cMatchesPublishedTable() async throws {
        // Bühlmann, Tauchmedizin (2002), in bar; cross-checked against Subsurface core/deco.cpp.
        let published: [[Double]] = [
            [5.0, 1.1696, 0.5578, 1.88, 1.6189, 0.4770],
            [8.0, 1.0000, 0.6514, 3.02, 1.3830, 0.5747],
            [12.5, 0.8618, 0.7222, 4.72, 1.1919, 0.6527],
            [18.5, 0.7562, 0.7825, 6.99, 1.0458, 0.7223],
            [27.0, 0.6200, 0.8126, 10.21, 0.9220, 0.7582],
            [38.3, 0.5043, 0.8434, 14.48, 0.8205, 0.7957],
            [54.3, 0.4410, 0.8693, 20.53, 0.7305, 0.8279],
            [77.0, 0.4000, 0.8910, 29.11, 0.6502, 0.8553],
            [109.0, 0.3750, 0.9092, 41.20, 0.5950, 0.8757],
            [146.0, 0.3500, 0.9222, 55.19, 0.5545, 0.8903],
            [187.0, 0.3295, 0.9319, 70.69, 0.5333, 0.8997],
            [239.0, 0.3065, 0.9403, 90.34, 0.5189, 0.9073],
            [305.0, 0.2835, 0.9477, 115.29, 0.5181, 0.9122],
            [390.0, 0.2610, 0.9544, 147.42, 0.5176, 0.9171],
            [498.0, 0.2480, 0.9602, 188.24, 0.5172, 0.9217],
            [635.0, 0.2327, 0.9653, 240.03, 0.5119, 0.9267]
        ]
        try await given {
            Buhlmann.Table.zhl16c
        } when: { table in
            table.rows
        } then: { _, rows in
            try #require(rows.count == published.count)
            for (row, expected) in zip(rows, published) {
                #expect(row.nitrogen.halfTime.value == expected[0])
                #expect((row.nitrogen.coefficientA.value * 1.01325).isApproximately(expected[1]))
                #expect(row.nitrogen.coefficientB == expected[2])
                #expect(row.helium.halfTime.value == expected[3])
                #expect((row.helium.coefficientA.value * 1.01325).isApproximately(expected[4]))
                #expect(row.helium.coefficientB == expected[5])
            }
        }
    }

    @Test
    func publishedCoefficientsAreConvertedFromBarToAtmospheres() async {
        await given {
            Buhlmann.Table.zhl16c
        } when: { table in
            table.rows[0]
        } then: { _, first in
            #expect(first.nitrogen.coefficientA.value.isApproximately(1.1696 / 1.01325))
            #expect(first.helium.coefficientA.value.isApproximately(1.6189 / 1.01325))
        }
    }

    @Test
    func singleGasToleratedPressureAtFullGradientFactorIsBuhlmannLimit() async throws {
        try await given {
            try Self.compartment(nitrogen: 2)
        } when: { compartment in
            try Self.table.toleratedAmbientPressure(of: compartment)
        } then: { _, tolerated in
            #expect(tolerated.value.isApproximately((2 - 0.5) * 0.8))
        }
    }

    @Test
    func lowerGradientFactorGivesHigherToleratedPressure() async throws {
        try await given {
            try Self.compartment(nitrogen: 2)
        } when: { compartment in
            (full: try Self.table.toleratedAmbientPressure(of: compartment),
             half: try Self.table.toleratedAmbientPressure(of: compartment, gradientFactor: try .init(0.5)))
        } then: { _, tolerated in
            #expect(tolerated.half.value.isApproximately((2 - 0.25) / (0.5 / 0.8 - 0.5 + 1)))
            #expect(tolerated.half.value > tolerated.full.value)
        }
    }

    @Test
    func mixedGasCoefficientsAreWeightedByTension() async throws {
        try await given {
            try Self.compartment(nitrogen: 1, helium: 1)
        } when: { compartment in
            try Self.table.toleratedAmbientPressure(of: compartment)
        } then: { _, tolerated in
            #expect(tolerated.value.isApproximately((2 - 0.75) * 0.7))
        }
    }

    @Test
    func heliumOnlyTensionUsesHeliumCoefficients() async throws {
        try await given {
            try Self.compartment(nitrogen: 0, helium: 1.5)
        } when: { compartment in
            try Self.table.toleratedAmbientPressure(of: compartment)
        } then: { _, tolerated in
            #expect(tolerated.value.isApproximately((1.5 - 1) * 0.6))
        }
    }

    @Test
    func singleGasCompartmentMatchesAnyRowWithItsHalfTime() async throws {
        try await given {
            (nitrogen: Tissue.Compartment(try .init(of: .nitrogen, halfTime: .init(8), tension: .init(2))),
             helium: Tissue.Compartment(try .init(of: .helium, halfTime: .init(3.02), tension: .init(2))))
        } when: { compartments in
            (nitrogen: try Buhlmann.Table.zhl16c.toleratedAmbientPressure(of: compartments.nitrogen),
             helium: try Buhlmann.Table.zhl16c.toleratedAmbientPressure(of: compartments.helium))
        } then: { _, tolerated in
            // Row 2: nitrogen a 1.0 bar, b 0.6514; helium a 1.383 bar, b 0.5747.
            #expect(tolerated.nitrogen.value.isApproximately((2 - 1 / 1.01325) * 0.6514))
            #expect(tolerated.helium.value.isApproximately((2 - 1.383 / 1.01325) * 0.5747))
        }
    }

    @Test
    func maximalACoefficientsStayFiniteWhenWeighted() async throws {
        // These tensions give weights that round to a sum above 1, so the weighted
        // `a` overflows unless clamped; the tension is far below `a`, so any pressure is tolerated.
        try await given {
            try Self.compartment(nitrogen: 1, helium: 0.06793378374292536)
        } when: { compartment in
            (tolerated: try Self.maximalATable.toleratedAmbientPressure(of: compartment),
             ceiling: try Self.maximalATable.ceiling(of: [compartment], configuration: .init(units: .metric, water: .salt)))
        } then: { _, result in
            #expect(result.tolerated.value == 0)
            #expect(result.ceiling.result.value == 0)
        }
    }

    @Test
    func largeFiniteTensionsKeepTensionWeighting() async throws {
        // The sum overflows if computed directly; weighting by the largest tension keeps it finite.
        try await given {
            try Self.compartment(nitrogen: 1e308, helium: 1e308)
        } when: { compartment in
            try Self.table.toleratedAmbientPressure(of: compartment)
        } then: { _, tolerated in
            #expect((tolerated.value / 1e308).isApproximately((2 - 0.75e-308) * 0.7, with: .loose))
        }
    }

    @Test
    func subnormalTensionsTolerateAnyPressure() async throws {
        // Dividing `a` by a subnormal tension would overflow; the result must still clamp to 0.
        try await given {
            try Self.compartment(nitrogen: 1e-320, helium: 1e-320)
        } when: { compartment in
            (single: try Buhlmann.Table.zhl16c.toleratedAmbientPressure(
                of: Tissue.Compartment(try .init(of: .nitrogen, halfTime: .init(5), tension: .init(1e-320)))),
             mixed: try Self.table.toleratedAmbientPressure(of: compartment))
        } then: { _, tolerated in
            #expect(tolerated.single.value == 0)
            #expect(tolerated.mixed.value == 0)
        }
    }

    @Test
    func compartmentWithoutInertGasToleratesAnyPressure() async throws {
        try await given {
            try Self.compartment(nitrogen: 0, helium: 0)
        } when: { compartment in
            try Self.table.toleratedAmbientPressure(of: compartment)
        } then: { _, tolerated in
            #expect(tolerated.value == 0)
        }
    }

    @Test
    func toleratedPressureIsNeverNegative() async throws {
        try await given {
            try Self.compartment(nitrogen: 0.4)
        } when: { compartment in
            try Self.table.toleratedAmbientPressure(of: compartment)
        } then: { _, tolerated in
            #expect(tolerated.value == 0)
        }
    }

    @Test(arguments: [
        // 10 or 33 per atmosphere above the surface: (1.75 / 1.125 - 1) atmospheres.
        (units: Units.metric, water: Water.salt, depth: 5.555555555555555, unit: Depth.Unit.meters),
        (units: Units.imperial, water: Water.salt, depth: 18.333333333333332, unit: Depth.Unit.feet)
    ])
    func ceilingIsControlledByDeepestCompartment(units: Units, water: Water, depth: Double, unit: Depth.Unit) async throws {
        try await given {
            [
                try Self.compartment(nitrogen: 2),
                try Self.compartment(nitrogen: 1.2)
            ]
        } when: { compartments in
            try Self.table.ceiling(
                of: compartments,
                gradientFactor: try .init(0.5),
                configuration: .init(units: units, water: water))
        } then: { _, ceiling in
            #expect(ceiling.result.value.isApproximately(depth))
            #expect(ceiling.result.unit == unit)
        }
    }

    @Test
    func ceilingIsSurfaceWhenEveryCompartmentToleratesIt() async throws {
        try await given {
            try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74))
        } when: { compartments in
            (saturated: try Buhlmann.Table.zhl16c.ceiling(of: compartments, configuration: .init(units: .metric, water: .salt)),
             empty: try Buhlmann.Table.zhl16c.ceiling(of: [], configuration: .init(units: .metric, water: .salt)))
        } then: { _, ceiling in
            #expect(ceiling.saturated.result.value == 0)
            #expect(ceiling.empty.result.value == 0)
        }
    }

    @Test(arguments: [
        // Expected values were calculated separately with 50-digit decimal arithmetic.
        (minutes: 30.0, nitrogen: 3.1, helium: 0.0, gradientFactor: 1.0, depth: 3.016449948805441),
        (minutes: 30.0, nitrogen: 3.1, helium: 0.0, gradientFactor: 0.5, depth: 9.179342238227694),
        (minutes: 20.0, nitrogen: 2.59, helium: 3.15, gradientFactor: 0.8, depth: 19.988528920866735)
    ])
    func squareProfileMatchesIndependentCalculation(
        minutes: Double,
        nitrogen: Double,
        helium: Double,
        gradientFactor: Double,
        depth: Double) async throws {
            try await given {
                try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74))
            } when: { compartments in
                let loaded = try compartments.map { compartment in
                    let result = try compartment.loaded(
                        for: .init(minutes),
                        inspired: try .init(of: .nitrogen, pressure: .init(nitrogen)),
                        try .init(of: .helium, pressure: .init(helium)),
                        using: .haldane)
                    return try #require(result.tracked)
                }
                return try Buhlmann.Table.zhl16c.ceiling(
                    of: loaded,
                    gradientFactor: try .init(gradientFactor),
                    configuration: .init(units: .metric, water: .salt))
            } then: { _, ceiling in
                #expect(ceiling.result.value.isApproximately(depth))
            }
        }

    @Test
    func ceilingDoesNotDependOnCompartmentOrder() async throws {
        try await given {
            try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74)).map { compartment in
                try #require(try compartment.loaded(
                    for: .init(30),
                    inspired: try .init(of: .nitrogen, pressure: .init(3.1)),
                    using: .haldane).tracked)
            }
        } when: { compartments in
            let configuration = Configuration(units: .metric, water: .salt)
            return (inOrder: try Buhlmann.Table.zhl16c.ceiling(of: compartments, configuration: configuration),
                    reversed: try Buhlmann.Table.zhl16c.ceiling(of: compartments.reversed(), configuration: configuration))
        } then: { _, ceiling in
            #expect(ceiling.inOrder == ceiling.reversed)
            #expect(ceiling.inOrder.result.value > 0)
        }
    }

    @Test
    func tableCompartmentsStartAtGivenTensions() async throws {
        try await given {
            Buhlmann.Table.zhl16c
        } when: { table in
            try table.compartments(nitrogen: .init(0.74), helium: .init(0.1))
        } then: { table, compartments in
            try #require(compartments.count == table.rows.count)
            for (compartment, row) in zip(compartments, table.rows) {
                #expect(compartment.tracking(of: .nitrogen) == .tracked(halfTime: row.nitrogen.halfTime, tension: .init(0.74)))
                #expect(compartment.tracking(of: .helium) == .tracked(halfTime: row.helium.halfTime, tension: .init(0.1)))
            }
        }
    }
}

private extension BuhlmannTests {
    /// A one-row table: nitrogen at 5 minutes (a 0.5, b 0.8) and helium at 2 minutes (a 1, b 0.6).
    static var table: Buhlmann.Table {
        get throws {
            .init([
                .init(
                    nitrogen: try .init(of: .nitrogen, halfTime: .init(5), a: .init(0.5), b: 0.8),
                    helium: try .init(of: .helium, halfTime: .init(2), a: .init(1), b: 0.6))
            ])
        }
    }

    /// A one-row table with both `a` at `greatestFiniteMagnitude`, at the same half-times as ``table``.
    static var maximalATable: Buhlmann.Table {
        get throws {
            .init([
                .init(
                    nitrogen: try .init(of: .nitrogen, halfTime: .init(5), a: .init(.greatestFiniteMagnitude), b: 0.8),
                    helium: try .init(of: .helium, halfTime: .init(2), a: .init(.greatestFiniteMagnitude), b: 0.6))
            ])
        }
    }

    static func compartment(nitrogen tension: Double) throws -> Tissue.Compartment {
        Tissue.Compartment(try .init(of: .nitrogen, halfTime: .init(5), tension: .init(tension)))
    }

    static func compartment(nitrogen: Double, helium: Double) throws -> Tissue.Compartment {
        Tissue.Compartment(
            try .init(of: .nitrogen, halfTime: .init(5), tension: .init(nitrogen)),
            try .init(of: .helium, halfTime: .init(2), tension: .init(helium)))
    }
}
