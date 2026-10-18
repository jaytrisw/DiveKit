import Testing
@_spi(Experimental) @testable import DiveKit
@_spi(Experimental) import DiveKitTestSupport

@Suite("Bühlmann validation", .tags(.technicalDiving, .buhlmann, .error))
struct BuhlmannValidationTests {
    @Test
    func coefficientsRejectMetabolicGas() async throws {
        try await given {
            Oxygen()
        } when: { gas in
            try expectThrowsError(
                when: try Buhlmann.Coefficients(of: gas, halfTime: .init(5), a: .init(1), b: 0.5),
                then: .gas(.metabolic(gas), "Coefficients<Oxygen>.init(of:halfTime:a:b:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.gas.metabolic")
            }
        }
    }

    @Test
    func coefficientsRejectZeroHalfTime() async throws {
        try await given {
            Minutes(0)
        } when: { halfTime in
            try expectThrowsError(
                when: try Buhlmann.Coefficients(of: .nitrogen, halfTime: halfTime, a: .init(1), b: 0.5),
                then: .range(.lowerBound(0, 0), "Coefficients<Nitrogen>.init(of:halfTime:a:b:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.range.lower.bound")
            }
        }
    }

    @Test
    func coefficientsRejectNegativeA() async throws {
        try await given {
            PartialPressure<Nitrogen>(-1)
        } when: { coefficientA in
            try expectThrowsError(
                when: try Buhlmann.Coefficients(of: .nitrogen, halfTime: .init(5), a: coefficientA, b: 0.5),
                then: .negative(.partialPressure(-1), "Coefficients<Nitrogen>.init(of:halfTime:a:b:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.partial.pressure")
            }
        }
    }

    @Test
    func coefficientsRejectInfiniteA() async throws {
        try await given {
            PartialPressure<Helium>(.infinity)
        } when: { coefficientA in
            try expectThrowsError(
                when: try Buhlmann.Coefficients(of: .helium, halfTime: .init(5), a: coefficientA, b: 0.5),
                then: .range(.upperBound(.infinity, .greatestFiniteMagnitude), "Coefficients<Helium>.init(of:halfTime:a:b:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test(arguments: [
        (coefficientB: 0.0, expected: Error.Range.lowerBound(0, 0.01), key: "dive.kit.error.range.lower.bound"),
        (coefficientB: 0.009, expected: Error.Range.lowerBound(0.009, 0.01), key: "dive.kit.error.range.lower.bound"),
        (coefficientB: 5e-324, expected: Error.Range.lowerBound(5e-324, 0.01), key: "dive.kit.error.range.lower.bound"),
        (coefficientB: 1.5, expected: Error.Range.upperBound(1.5, 1), key: "dive.kit.error.range.upper.bound"),
        (
            coefficientB: .infinity,
            expected: Error.Range.upperBound(.infinity, .greatestFiniteMagnitude),
            key: "dive.kit.error.range.upper.bound")
    ])
    func coefficientsRejectInvalidB(coefficientB: Double, expected: Error.Range, key: String) async throws {
        try await given {
            coefficientB
        } when: { coefficientB in
            try expectThrowsError(
                when: try Buhlmann.Coefficients(of: .nitrogen, halfTime: .init(5), a: .init(1), b: coefficientB),
                then: .range(expected, "Coefficients<Nitrogen>.init(of:halfTime:a:b:)")) { error in
                #expect(error.localizationValue == .init(key))
            }
        }
    }

    @Test
    func coefficientsRejectNaNB() async throws {
        try await given {
            Double.nan
        } when: { coefficientB in
            expectThrowsNaNUpperBound(when: try Buhlmann.Coefficients(of: .nitrogen, halfTime: .init(5), a: .init(1), b: coefficientB), callSite: "Coefficients<Nitrogen>.init(of:halfTime:a:b:)")
        }
    }

    @Test(arguments: [
        (value: 0.0, expected: Error.Range.lowerBound(0, 0.01), key: "dive.kit.error.range.lower.bound"),
        (value: -0.2, expected: Error.Range.lowerBound(-0.2, 0.01), key: "dive.kit.error.range.lower.bound"),
        (value: 0.009, expected: Error.Range.lowerBound(0.009, 0.01), key: "dive.kit.error.range.lower.bound"),
        (value: 1.01, expected: Error.Range.upperBound(1.01, 1), key: "dive.kit.error.range.upper.bound"),
        (
            value: .infinity,
            expected: Error.Range.upperBound(.infinity, .greatestFiniteMagnitude),
            key: "dive.kit.error.range.upper.bound")
    ])
    func gradientFactorRejectsInvalidValues(value: Double, expected: Error.Range, key: String) async throws {
        try await given {
            value
        } when: { value in
            try expectThrowsError(
                when: try GradientFactor(value),
                then: .range(expected, "GradientFactor.init(_:)")) { error in
                #expect(error.localizationValue == .init(key))
            }
        }
    }

    @Test
    func gradientFactorRejectsNaN() async throws {
        try await given {
            Double.nan
        } when: { value in
            expectThrowsNaNUpperBound(when: try GradientFactor(value), callSite: "GradientFactor.init(_:)")
        }
    }

    @Test
    func gradientFactorAcceptsOne() async throws {
        try await given {
            1.0
        } when: { value in
            try GradientFactor(value)
        } then: { _, gradientFactor in
            #expect(gradientFactor == .full)
        }
    }

    @Test
    func minimumBAndGradientFactorAreAccepted() async throws {
        try await given {
            0.01
        } when: { minimum in
            (coefficients: try Buhlmann.Coefficients(of: .nitrogen, halfTime: .init(5), a: .init(1), b: minimum),
             gradientFactor: try GradientFactor(minimum))
        } then: { _, result in
            #expect(result.coefficients.coefficientB == 0.01)
            #expect(result.gradientFactor.value == 0.01)
        }
    }

    @Test
    func tableRejectsInfiniteHeliumTension() async throws {
        try await given {
            PartialPressure<Helium>(.infinity)
        } when: { helium in
            try expectThrowsError(
                when: try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74), helium: helium),
                then: .range(.upperBound(.infinity, .greatestFiniteMagnitude), "Table.compartments(nitrogen:helium:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test
    func emptyTableStillValidatesTensions() async throws {
        try await given {
            Buhlmann.Table([])
        } when: { table in
            try expectThrowsError(
                when: try table.compartments(nitrogen: .init(-1)),
                then: .negative(.partialPressure(-1), "Table.compartments(nitrogen:helium:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.partial.pressure")
            }
        }
    }

    @Test
    func toleratedPressureRejectsGasWithoutCoefficients() async throws {
        try await given {
            Tissue.Compartment(try .init(of: Neon(), halfTime: .init(5), tension: .init(0.5)))
        } when: { compartment in
            try expectThrowsError(
                when: try Buhlmann.Table.zhl16c.toleratedAmbientPressure(of: compartment),
                then: .gas(.unmodeled(Neon()), "Table.toleratedAmbientPressure(of:gradientFactor:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.gas.unmodeled")
            }
        }
    }

    @Test
    func toleratedPressureRejectsHalfTimeMissingFromTable() async throws {
        try await given {
            Tissue.Compartment(try .init(of: .nitrogen, halfTime: .init(6), tension: .init(0.5)))
        } when: { compartment in
            try expectThrowsError(
                when: try Buhlmann.Table.zhl16c.toleratedAmbientPressure(of: compartment),
                then: .gas(.unmodeled(Nitrogen()), "Table.toleratedAmbientPressure(of:gradientFactor:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.gas.unmodeled")
            }
        }
    }

    @Test
    func toleratedPressureRejectsGasesFromDifferentRows() async throws {
        // 5-minute nitrogen is row 1 and 3.02-minute helium is row 2; ZH-L16C defines no such compartment.
        try await given {
            Tissue.Compartment(
                try .init(of: .nitrogen, halfTime: .init(5), tension: .init(0.5)),
                try .init(of: .helium, halfTime: .init(3.02), tension: .init(0.5)))
        } when: { compartment in
            try expectThrowsError(
                when: try Buhlmann.Table.zhl16c.toleratedAmbientPressure(of: compartment),
                then: .gas(.unmodeled(Nitrogen()), "Table.toleratedAmbientPressure(of:gradientFactor:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.gas.unmodeled")
            }
        }
    }

    @Test
    func ceilingReportsGasWithoutCoefficients() async throws {
        try await given {
            try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74))
                + [Tissue.Compartment(try .init(of: .helium, halfTime: .init(4), tension: .init(0.1)))]
        } when: { compartments in
            try expectThrowsError(
                when: try Buhlmann.Table.zhl16c.ceiling(of: compartments, configuration: .init(units: .metric, water: .salt)),
                then: .gas(.unmodeled(Helium.helium), "Table.ceiling(of:gradientFactor:configuration:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.gas.unmodeled")
            }
        }
    }

    @Test
    func toleratedPressureRejectsOverflowingTensions() async throws {
        // Each tension is finite, but their sum and the tolerated pressure are not.
        try await given {
            Tissue.Compartment(
                try .init(of: .nitrogen, halfTime: .init(5), tension: .init(.greatestFiniteMagnitude)),
                try .init(of: .helium, halfTime: .init(1.88), tension: .init(.greatestFiniteMagnitude)))
        } when: { compartment in
            try expectThrowsError(
                when: try Buhlmann.Table.zhl16c.toleratedAmbientPressure(of: compartment),
                then: .range(.upperBound(.infinity, .greatestFiniteMagnitude), "Table.toleratedAmbientPressure(of:gradientFactor:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test
    func ceilingRejectsOverflowingDepth() async throws {
        // The tolerated pressure is finite, but converting it to depth is not.
        try await given {
            Tissue.Compartment(try .init(of: .nitrogen, halfTime: .init(5), tension: .init(.greatestFiniteMagnitude)))
        } when: { compartment in
            try expectThrowsError(
                when: try Buhlmann.Table.zhl16c.ceiling(of: [compartment], configuration: .init(units: .metric, water: .salt)),
                then: .range(.upperBound(.infinity, .greatestFiniteMagnitude), "Table.ceiling(of:gradientFactor:configuration:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test(arguments: [
        (increase: 0.0, expected: Error.Range.lowerBound(0, 0), key: "dive.kit.error.range.lower.bound"),
        (increase: -10, expected: Error.Range.lowerBound(-10, 0), key: "dive.kit.error.range.lower.bound"),
        (increase: .infinity, expected: Error.Range.upperBound(.infinity, .greatestFiniteMagnitude), key: "dive.kit.error.range.upper.bound"),
        (increase: -.infinity, expected: Error.Range.upperBound(-.infinity, .greatestFiniteMagnitude), key: "dive.kit.error.range.upper.bound")
    ])
    func ceilingRejectsInvalidDepthPerAtmosphere(increase: Double, expected: Error.Range, key: String) async throws {
        // The compartment tolerates the surface, so the water is rejected before any depth is derived from it.
        try await given {
            (compartment: Tissue.Compartment(try .init(of: .nitrogen, halfTime: .init(5), tension: .init(0.74))),
             configuration: Configuration(
                units: .metric,
                water: Water(weight: Water.salt.weight, pressure: { .init(increase: .init(increase, units: $0)) })))
        } when: { input in
            try expectThrowsError(
                when: try Buhlmann.Table.zhl16c.ceiling(of: [input.compartment], configuration: input.configuration),
                then: .range(expected, "Table.ceiling(of:gradientFactor:configuration:)")) { error in
                #expect(error.localizationValue == .init(key))
            }
        }
    }

    @Test(.tags(.localization))
    func unmodeledGasErrorHasLocalizedDescription() async {
        await withTestLocalization(.test) {
            await given {
                DiveKit.Error.gas(.unmodeled(Neon()), #function)
            } when: { sut in
                sut.localizedDescription
            } then: { _, result in
                #expect(result == "No decompression table row has coefficients for this gas at its half-time")
            }
        }
    }
}
