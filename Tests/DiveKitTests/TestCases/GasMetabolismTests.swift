import Testing
@_spi(Experimental) @testable import DiveKit

@Suite("Gas metabolism", .tags(.technicalDiving))
struct GasMetabolismTests {
    @Test
    func builtInGasesDeclareTheirMetabolism() async {
        await given {
            (oxygen: Oxygen.oxygen, nitrogen: Nitrogen.nitrogen, helium: Helium.helium, trace: Trace.trace)
        } when: { gases in
            (oxygen: metabolism(of: gases.oxygen),
             nitrogen: metabolism(of: gases.nitrogen),
             helium: metabolism(of: gases.helium),
             trace: metabolism(of: gases.trace))
        } then: { _, metabolism in
            #expect(metabolism.oxygen == .metabolic)
            #expect(metabolism.nitrogen == .inert)
            #expect(metabolism.helium == .inert)
            #expect(metabolism.trace == .inert)
        }
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
}
