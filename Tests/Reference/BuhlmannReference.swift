// Independent reference values for DiveKit's tissue loading, ceiling and
// no-decompression-limit tests.
//
// Run from the repository root:
//
//     swift Tests/Reference/BuhlmannReference.swift
//
// Everything is computed with Foundation's `Decimal` (38 significant digits)
// and this file's own `exp` and `ln`, without DiveKit or `Double` math, so the
// tests compare DiveKit against a separate implementation of the published
// formulas. Each section prints the values a test asserts.

import Foundation

// MARK: Decimal math

/// e^x by halving until |x| is small, a Taylor series, then squaring back.
func exp(_ value: Decimal) -> Decimal {
    var reduced = value
    var halvings = 0
    while abs(reduced) > Decimal(string: "0.0001")! {
        reduced /= 2
        halvings += 1
    }
    var term = Decimal(1)
    var sum = Decimal(1)
    // Stop well before `Decimal` underflows, which yields NaN.
    for index in 1...40 where abs(term) > Decimal(string: "1e-60")! {
        term = term * reduced / Decimal(index)
        sum += term
    }
    for _ in 0..<halvings {
        sum *= sum
    }
    return sum
}

/// ln 2 = 2·atanh(1/3) = 2·Σ (1/3)^(2n+1) / (2n+1).
let ln2: Decimal = {
    let third = Decimal(1) / Decimal(3)
    let ninth = third * third
    var power = third
    var sum = Decimal(0)
    for index in 0..<60 {
        sum += power / Decimal(2 * index + 1)
        power *= ninth
    }
    return 2 * sum
}()

func abs(_ value: Decimal) -> Decimal {
    value < 0 ? -value : value
}

func decimal(_ string: String) -> Decimal {
    Decimal(string: string)!
}

// MARK: Model

/// Water vapour 0.0627 bar, in atmospheres.
let waterVapor = decimal("0.0627") / decimal("1.01325")
/// Metric salt water: 10 m per atmosphere.
let metresPerAtmosphere = Decimal(10)

struct Coefficients {
    let halfTime: Decimal
    /// Bühlmann's `a` in atmospheres, converted from bar.
    let coefficientA: Decimal
    /// Bühlmann's `b`.
    let coefficientB: Decimal

    init(_ halfTime: String, bar: String, b coefficientB: String) {
        self.halfTime = decimal(halfTime)
        self.coefficientA = decimal(bar) / decimal("1.01325")
        self.coefficientB = decimal(coefficientB)
    }

    var rate: Decimal { ln2 / halfTime }
}

/// ZH-L16C, compartments 1b to 16: Bühlmann, *Tauchmedizin* (2002).
let zhl16c: [(nitrogen: Coefficients, helium: Coefficients)] = [
    (.init("5.0", bar: "1.1696", b: "0.5578"), .init("1.88", bar: "1.6189", b: "0.4770")),
    (.init("8.0", bar: "1.0000", b: "0.6514"), .init("3.02", bar: "1.3830", b: "0.5747")),
    (.init("12.5", bar: "0.8618", b: "0.7222"), .init("4.72", bar: "1.1919", b: "0.6527")),
    (.init("18.5", bar: "0.7562", b: "0.7825"), .init("6.99", bar: "1.0458", b: "0.7223")),
    (.init("27.0", bar: "0.6200", b: "0.8126"), .init("10.21", bar: "0.9220", b: "0.7582")),
    (.init("38.3", bar: "0.5043", b: "0.8434"), .init("14.48", bar: "0.8205", b: "0.7957")),
    (.init("54.3", bar: "0.4410", b: "0.8693"), .init("20.53", bar: "0.7305", b: "0.8279")),
    (.init("77.0", bar: "0.4000", b: "0.8910"), .init("29.11", bar: "0.6502", b: "0.8553")),
    (.init("109.0", bar: "0.3750", b: "0.9092"), .init("41.20", bar: "0.5950", b: "0.8757")),
    (.init("146.0", bar: "0.3500", b: "0.9222"), .init("55.19", bar: "0.5545", b: "0.8903")),
    (.init("187.0", bar: "0.3295", b: "0.9319"), .init("70.69", bar: "0.5333", b: "0.8997")),
    (.init("239.0", bar: "0.3065", b: "0.9403"), .init("90.34", bar: "0.5189", b: "0.9073")),
    (.init("305.0", bar: "0.2835", b: "0.9477"), .init("115.29", bar: "0.5181", b: "0.9122")),
    (.init("390.0", bar: "0.2610", b: "0.9544"), .init("147.42", bar: "0.5176", b: "0.9171")),
    (.init("498.0", bar: "0.2480", b: "0.9602"), .init("188.24", bar: "0.5172", b: "0.9217")),
    (.init("635.0", bar: "0.2327", b: "0.9653"), .init("240.03", bar: "0.5119", b: "0.9267"))
]

/// Haldane: P(t) = Pᵢ + (P₀ − Pᵢ)·e^(−kt).
func haldane(initial: Decimal, inspired: Decimal, rate: Decimal, minutes: Decimal) -> Decimal {
    inspired + (initial - inspired) * exp(-rate * minutes)
}

/// Schreiner: P(t) = Pᵢ + R(t − 1/k) − (Pᵢ − P₀ − R/k)·e^(−kt), with R the
/// change in inspired pressure per minute.
func schreiner(initial: Decimal, from start: Decimal, to end: Decimal, rate: Decimal, minutes: Decimal) -> Decimal {
    let change = (end - start) / minutes
    return start + change * (minutes - 1 / rate) - (start - initial - change / rate) * exp(-rate * minutes)
}

/// Baker's tolerated ambient pressure, (P − a·GF) / (GF/b − GF + 1), with `a`
/// and `b` weighted by each gas's tension.
func tolerated(nitrogen: Decimal, helium: Decimal, row: (nitrogen: Coefficients, helium: Coefficients), gradientFactor: Decimal) -> Decimal {
    let total = nitrogen + helium
    guard total > 0 else { return 0 }
    let weightedA = (row.nitrogen.coefficientA * nitrogen + row.helium.coefficientA * helium) / total
    let weightedB = (row.nitrogen.coefficientB * nitrogen + row.helium.coefficientB * helium) / total
    let value = (total - weightedA * gradientFactor) / (gradientFactor / weightedB - gradientFactor + 1)
    return value > 0 ? value : 0
}

// MARK: TissueLoadingTests.schreinerIsExactDuringLinearChange

print("Schreiner, 10 minutes, N₂ 1 → 2 atm (half-time 10, from 0.7), He 0.4 → 0.1 atm (half-time 5, from 0.2):")
print("  nitrogen", schreiner(initial: decimal("0.7"), from: 1, to: 2, rate: ln2 / 10, minutes: 10))
print("  helium  ", schreiner(initial: decimal("0.2"), from: decimal("0.4"), to: decimal("0.1"), rate: ln2 / 5, minutes: 10))

// MARK: BuhlmannTests.squareProfileMatchesIndependentCalculation (ceiling)

print("\nCeiling after Haldane loading from N₂ 0.74, He 0, metric salt water:")
for (minutes, nitrogen, helium, gradientFactor) in [
    ("30", "3.1", "0", "1"),
    ("30", "3.1", "0", "0.5"),
    ("20", "2.59", "3.15", "0.8")
] {
    let toleratedMax = zhl16c.map { row in
        tolerated(
            nitrogen: haldane(initial: decimal("0.74"), inspired: decimal(nitrogen), rate: row.nitrogen.rate, minutes: decimal(minutes)),
            helium: haldane(initial: 0, inspired: decimal(helium), rate: row.helium.rate, minutes: decimal(minutes)),
            row: row,
            gradientFactor: decimal(gradientFactor))
    }.max()!
    let depth = toleratedMax > 1 ? (toleratedMax - 1) * metresPerAtmosphere : 0
    print("  \(minutes) min, N₂ \(nitrogen), He \(helium), GF \(gradientFactor): \(depth) m")
}

// MARK: BuhlmannNoDecompressionLimitTests.squareProfileMatchesIndependentCalculation

print("\nNo-decompression limit from N₂ 0.74, He 0, metric salt water:")
for (depth, oxygen, helium, gradientFactor) in [
    ("30", "0.21", "0", "1"),
    ("18", "0.21", "0", "1"),
    ("30", "0.32", "0", "0.85"),
    ("40", "0.18", "0.45", "1")
] {
    let breathed = 1 + decimal(depth) / metresPerAtmosphere - waterVapor
    let nitrogenFraction = 1 - decimal(oxygen) - decimal(helium)
    func ceilingTolerance(after minutes: Decimal) -> Decimal {
        zhl16c.map { row in
            tolerated(
                nitrogen: haldane(initial: decimal("0.74"), inspired: breathed * nitrogenFraction, rate: row.nitrogen.rate, minutes: minutes),
                helium: haldane(initial: 0, inspired: breathed * decimal(helium), rate: row.helium.rate, minutes: minutes),
                row: row,
                gradientFactor: decimal(gradientFactor))
        }.max()!
    }
    // Every gas is loading, so the largest tolerated pressure only rises, and
    // bisection finds the moment it reaches one atmosphere.
    var low = Decimal(0)
    var high = Decimal(999)
    for _ in 0..<80 {
        let middle = (low + high) / 2
        if ceilingTolerance(after: middle) > 1 {
            high = middle
        } else {
            low = middle
        }
    }
    var whole = Decimal()
    var exact = low
    NSDecimalRound(&whole, &exact, 0, .down)
    print("  \(depth) m, O₂ \(oxygen), He \(helium), GF \(gradientFactor): ceiling appears after \(low) min, so \(whole) whole minutes")
}
