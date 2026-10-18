import Testing
@_spi(Experimental) @testable import DiveKit
import DiveKitTestSupport

/// `add` and `update` in both their mutating and non-mutating forms.
@Suite("Blend Unblended mutations", .tags(.blend))
struct BlendUnblendedMutationTests {
    enum Mutation: CaseIterable, Sendable {
        case add
        case addFractionalPressure
        case update
        case updateFractionalPressure
        case adding
        case addingFractionalPressure
        case updating
        case updatingFractionalPressure

        var callSite: CallSite {
            switch self {
                case .add: "Blend<Unblended>.add(_:pressure:)"
                case .addFractionalPressure: "Blend<Unblended>.add(_:)"
                case .update: "Blend<Unblended>.update(_:pressure:)"
                case .updateFractionalPressure: "Blend<Unblended>.update(_:)"
                case .adding: "Blend<Unblended>.adding(_:pressure:)"
                case .addingFractionalPressure: "Blend<Unblended>.adding(_:)"
                case .updating: "Blend<Unblended>.updating(_:pressure:)"
                case .updatingFractionalPressure: "Blend<Unblended>.updating(_:)"
            }
        }

        /// Whether the mutation adds a gas, rather than updating one.
        var adds: Bool {
            switch self {
                case .add, .addFractionalPressure, .adding, .addingFractionalPressure: true
                case .update, .updateFractionalPressure, .updating, .updatingFractionalPressure: false
            }
        }

        func run(on blend: Blend<Unblended>, pressure: Double) throws {
            _ = try applied(to: blend, pressure: pressure)
        }

        func applied(to blend: Blend<Unblended>, pressure: Double) throws -> Blend<Unblended> {
            var blend = blend
            let fractionalPressure = FractionalPressure(.oxygen, fractionalPressure: pressure)
            switch self {
                case .add: try blend.add(.oxygen, pressure: pressure)
                case .addFractionalPressure: try blend.add(fractionalPressure)
                case .update: try blend.update(.oxygen, pressure: pressure)
                case .updateFractionalPressure: try blend.update(fractionalPressure)
                case .adding: blend = try blend.adding(.oxygen, pressure: pressure)
                case .addingFractionalPressure: blend = try blend.adding(fractionalPressure)
                case .updating: blend = try blend.updating(.oxygen, pressure: pressure)
                case .updatingFractionalPressure: blend = try blend.updating(fractionalPressure)
            }
            return blend
        }
    }

    @Test(.tags(.error), arguments: Mutation.allCases, [-0.8, 1.01])
    func mutationReportsItsOwnCallSite(mutation: Mutation, pressure: Double) async throws {
        try await given {
            let blend = Blend<Unblended>()
            let expectedError = Error.blend(.pressureRange(pressure, blend), mutation.callSite)
            return (blend: blend, expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try mutation.run(on: input.blend, pressure: pressure),
                then: input.expectedError) {
                    #expect($0.localizationValue == "dive.kit.error.blend.pressure.range")
                }
        }
    }

    @Test(.tags(.error), arguments: Mutation.allCases.filter(\.adds))
    func addRejectsGasAlreadyPresent(mutation: Mutation) async throws {
        try await given {
            let blend = try Blend<Unblended>().adding(.oxygen, pressure: 0.21)
            return (blend: blend, expectedError: Error.blend(.gasAlreadyPresent(Oxygen(), blend), mutation.callSite))
        } when: { input in
            try expectThrowsError(
                when: try mutation.run(on: input.blend, pressure: 0.32),
                then: input.expectedError) {
                    #expect($0.localizationValue == "dive.kit.error.blend.gas.already.present")
                }
        }
    }

    @Test(.tags(.error), arguments: Mutation.allCases.filter { !$0.adds })
    func updateRejectsGasNotPresent(mutation: Mutation) async throws {
        try await given {
            let blend = try Blend<Unblended>().adding(.nitrogen, pressure: 0.79)
            return (blend: blend, expectedError: Error.blend(.gasNotPresent(Oxygen(), blend), mutation.callSite))
        } when: { input in
            try expectThrowsError(
                when: try mutation.run(on: input.blend, pressure: 0.21),
                then: input.expectedError) {
                    #expect($0.localizationValue == "dive.kit.error.blend.gas.not.present")
                }
        }
    }

    @Test(arguments: Mutation.allCases)
    func mutationAppliesWhenPresenceMatches(mutation: Mutation) async throws {
        try await given {
            mutation.adds ? Blend<Unblended>() : try Blend<Unblended>().adding(.oxygen, pressure: 0.21)
        } when: { blend in
            try mutation.applied(to: blend, pressure: 0.32)
        } then: { _, result in
            #expect(result.fractionalPressure(of: .oxygen) == 0.32)
        }
    }

    @Test(.tags(.error), arguments: Mutation.allCases, [Double.infinity, -.infinity])
    func mutationRejectsInfinitePressureBeforeRange(mutation: Mutation, pressure: Double) async throws {
        try await given {
            Error.range(.upperBound(pressure, .greatestFiniteMagnitude), mutation.callSite)
        } when: { expectedError in
            try expectThrowsError(
                when: try mutation.run(on: Blend<Unblended>(), pressure: pressure),
                then: expectedError) {
                    #expect($0.localizationValue == "dive.kit.error.range.upper.bound")
                }
        }
    }

    @Test(.tags(.error), arguments: Mutation.allCases)
    func mutationRejectsNaNPressureBeforeRange(mutation: Mutation) async throws {
        try await given {
            mutation
        } when: { mutation in
            expectThrowsNaNUpperBound(when: try mutation.run(on: Blend<Unblended>(), pressure: .nan), callSite: mutation.callSite)
        }
    }
}
