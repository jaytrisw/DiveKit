import Testing
@_spi(Experimental) @testable import DiveKit

@Suite("Gas metabolism", .tags(.technicalDiving))
struct GasMetabolismTests {
    @Test
    func builtInGasesDeclareTheirMetabolism() async {
        await given {
            (oxygen: Oxygen.oxygen, nitrogen: Nitrogen.nitrogen, helium: Helium.helium)
        } when: { gases in
            (oxygen: metabolism(of: gases.oxygen),
             nitrogen: metabolism(of: gases.nitrogen),
             helium: metabolism(of: gases.helium))
        } then: { _, metabolism in
            #expect(metabolism.oxygen == .metabolic)
            #expect(metabolism.nitrogen == .inert)
            #expect(metabolism.helium == .inert)
        }
    }

    @Test
    func builtInGasesDeclareTheirNarcoticPotency() async {
        await given {
            (oxygen: Oxygen.oxygen, nitrogen: Nitrogen.nitrogen, helium: Helium.helium)
        } when: { gases in
            (oxygen: narcoticPotency(of: gases.oxygen),
             nitrogen: narcoticPotency(of: gases.nitrogen),
             helium: narcoticPotency(of: gases.helium))
        } then: { _, potency in
            #expect(potency.oxygen == .none)
            #expect(potency.nitrogen == .nitrogen)
            #expect(potency.helium == .none)
        }
    }

    @Test
    func narcoticPotencyComparesByValue() {
        #expect(NarcoticPotency.nitrogen == .relative(1))
        #expect(NarcoticPotency.relative(0) == .none)
        #expect(Set([NarcoticPotency.relative(0), .none]).count == 1)
        #expect(NarcoticPotency.relative(2.3) != .relative(1))
    }

    @Test(.tags(.error, .localization))
    func metabolicGasErrorHasLocalizedDescription() async {
        await withTestLocalization(.test) {
            await given {
                DiveKit.Error.gas(.metabolic(Oxygen()), #function)
            } when: { sut in
                sut.localizedDescription
            } then: { _, result in
                #expect(result == "Gas must be inert to be tracked by a tissue compartment")
            }
        }
    }

    // Reads through the protocol requirement, since `Helium` members are SPI in DiveKitCore.
    private func metabolism(of gas: some GasRepresentable) -> Metabolism {
        gas.metabolism
    }

    private func narcoticPotency(of gas: some GasRepresentable) -> NarcoticPotency {
        gas.narcoticPotency
    }
}
