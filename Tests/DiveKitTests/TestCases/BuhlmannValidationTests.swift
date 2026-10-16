import Testing
@_spi(Experimental) @testable import DiveKit

@Suite("Bühlmann validation", .tags(.technicalDiving, .buhlmann, .error))
struct BuhlmannValidationTests {
    @Test
    func coefficientsRejectMetabolicGas() throws {
        try expectThrowsError(
            when: try Buhlmann.Coefficients(of: Oxygen(), halfTime: .init(5), a: .init(1), b: 0.5),
            then: .gas(.metabolic(Oxygen()), "Coefficients<Oxygen>.init(of:halfTime:a:b:)")) { error in
            #expect(error.localizationValue == "dive.kit.error.gas.metabolic")
        }
    }

    @Test
    func coefficientsRejectZeroHalfTime() throws {
        try expectThrowsError(
            when: try Buhlmann.Coefficients(of: .nitrogen, halfTime: .init(0), a: .init(1), b: 0.5),
            then: .range(.lowerBound(0, 0), "Coefficients<Nitrogen>.init(of:halfTime:a:b:)")) { error in
            #expect(error.localizationValue == "dive.kit.error.range.lower.bound")
        }
    }

    @Test
    func coefficientsRejectNegativeA() throws {
        try expectThrowsError(
            when: try Buhlmann.Coefficients(of: .nitrogen, halfTime: .init(5), a: .init(-1), b: 0.5),
            then: .negative(.partialPressure(-1), "Coefficients<Nitrogen>.init(of:halfTime:a:b:)")) { error in
            #expect(error.localizationValue == "dive.kit.error.negative.partial.pressure")
        }
    }

    @Test
    func coefficientsRejectInfiniteA() throws {
        try expectThrowsError(
            when: try Buhlmann.Coefficients(of: .helium, halfTime: .init(5), a: .init(.infinity), b: 0.5),
            then: .range(.upperBound(.infinity, .greatestFiniteMagnitude), "Coefficients<Helium>.init(of:halfTime:a:b:)")) { error in
            #expect(error.localizationValue == "dive.kit.error.range.upper.bound")
        }
    }

    @Test(arguments: [
        (coefficientB: 0.0, expected: Error.Range.lowerBound(0, 0)),
        (coefficientB: 1.5, expected: Error.Range.upperBound(1.5, 1))
    ])
    func coefficientsRejectBOutsideUnitInterval(coefficientB: Double, expected: Error.Range) throws {
        try expectThrowsError(
            when: try Buhlmann.Coefficients(of: .nitrogen, halfTime: .init(5), a: .init(1), b: coefficientB),
            then: .range(expected, "Coefficients<Nitrogen>.init(of:halfTime:a:b:)"))
    }

    @Test
    func coefficientsRejectNaNB() {
        let error = #expect(throws: Error.self) {
            try Buhlmann.Coefficients(of: .nitrogen, halfTime: .init(5), a: .init(1), b: .nan)
        }
        #expect(error?.localizationValue == "dive.kit.error.range.lower.bound")
    }

    @Test(arguments: [
        (value: 0.0, expected: Error.Range.lowerBound(0, 0), key: "dive.kit.error.range.lower.bound"),
        (value: -0.2, expected: Error.Range.lowerBound(-0.2, 0), key: "dive.kit.error.range.lower.bound"),
        (value: 1.01, expected: Error.Range.upperBound(1.01, 1), key: "dive.kit.error.range.upper.bound")
    ])
    func gradientFactorRejectsValuesOutsideUnitInterval(value: Double, expected: Error.Range, key: String) throws {
        try expectThrowsError(
            when: try Buhlmann.GradientFactor(value),
            then: .range(expected, "GradientFactor.init(_:)")) { error in
            #expect(error.localizationValue == .init(key))
        }
    }

    @Test
    func gradientFactorAcceptsOne() throws {
        #expect(try Buhlmann.GradientFactor(1) == .full)
    }

    @Test
    func tableRejectsInfiniteHeliumTension() throws {
        try expectThrowsError(
            when: try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74), helium: .init(.infinity)),
            then: .range(.upperBound(.infinity, .greatestFiniteMagnitude), "Component<Helium>.init(of:halfTime:tension:)"))
    }

    @Test
    func toleratedPressureRejectsGasWithoutCoefficients() throws {
        let compartment = Tissue.Compartment(try .init(of: Neon(), halfTime: .init(5), tension: .init(0.5)))

        try expectThrowsError(
            when: try Buhlmann.Table.zhl16c.toleratedAmbientPressure(of: compartment),
            then: .gas(.unmodeled(Neon()), "Table.toleratedAmbientPressure(of:gradientFactor:)")) { error in
            #expect(error.localizationValue == "dive.kit.error.gas.unmodeled")
        }
    }

    @Test
    func toleratedPressureRejectsHalfTimeMissingFromTable() throws {
        let compartment = Tissue.Compartment(try .init(of: .nitrogen, halfTime: .init(6), tension: .init(0.5)))

        try expectThrowsError(
            when: try Buhlmann.Table.zhl16c.toleratedAmbientPressure(of: compartment),
            then: .gas(.unmodeled(Nitrogen()), "Table.toleratedAmbientPressure(of:gradientFactor:)"))
    }

    @Test
    func toleratedPressureRejectsGasesFromDifferentRows() throws {
        // 5-minute nitrogen is row 1 and 3.02-minute helium is row 2; ZH-L16C defines no such compartment.
        let compartment = Tissue.Compartment(
            try .init(of: .nitrogen, halfTime: .init(5), tension: .init(0.5)),
            try .init(of: .helium, halfTime: .init(3.02), tension: .init(0.5)))

        try expectThrowsError(
            when: try Buhlmann.Table.zhl16c.toleratedAmbientPressure(of: compartment),
            then: .gas(.unmodeled(Nitrogen()), "Table.toleratedAmbientPressure(of:gradientFactor:)")) { error in
            #expect(error.localizationValue == "dive.kit.error.gas.unmodeled")
        }
    }

    @Test
    func ceilingReportsGasWithoutCoefficients() throws {
        var compartments = try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74))
        compartments.append(Tissue.Compartment(try .init(of: .helium, halfTime: .init(4), tension: .init(0.1))))

        try expectThrowsError(
            when: try Buhlmann.Table.zhl16c.ceiling(of: compartments, configuration: .init(units: .metric, water: .salt)),
            then: .gas(.unmodeled(Helium.helium), "Table.ceiling(of:gradientFactor:configuration:)"))
    }

    @Test
    func toleratedPressureRejectsOverflowingTensions() throws {
        // Each tension is finite, but their sum and the tolerated pressure are not.
        let compartment = Tissue.Compartment(
            try .init(of: .nitrogen, halfTime: .init(5), tension: .init(.greatestFiniteMagnitude)),
            try .init(of: .helium, halfTime: .init(1.88), tension: .init(.greatestFiniteMagnitude)))

        try expectThrowsError(
            when: try Buhlmann.Table.zhl16c.toleratedAmbientPressure(of: compartment),
            then: .range(.upperBound(.infinity, .greatestFiniteMagnitude), "Table.toleratedAmbientPressure(of:gradientFactor:)")) { error in
            #expect(error.localizationValue == "dive.kit.error.range.upper.bound")
        }
    }

    @Test
    func ceilingRejectsOverflowingDepth() throws {
        // The tolerated pressure is finite, but converting it to depth is not.
        let compartment = Tissue.Compartment(
            try .init(of: .nitrogen, halfTime: .init(5), tension: .init(.greatestFiniteMagnitude)))

        try expectThrowsError(
            when: try Buhlmann.Table.zhl16c.ceiling(of: [compartment], configuration: .init(units: .metric, water: .salt)),
            then: .range(.upperBound(.infinity, .greatestFiniteMagnitude), "Table.ceiling(of:gradientFactor:configuration:)"))
    }

    @Test(.tags(.localization))
    func unmodeledGasErrorHasLocalizedDescription() async {
        await withTestLocalization(.test) {
            await given {
                DiveKit.Error.gas(.unmodeled(Neon()), #function)
            } when: { sut in
                sut.localizedDescription
            } then: { _, result in
                #expect(result == "Gas half-time has no matching row in the decompression table")
            }
        }
    }
}
