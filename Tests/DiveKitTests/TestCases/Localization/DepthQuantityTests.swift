import Testing
@testable import DiveKit

@Suite(.tags(.localization))
struct DepthQuantityTests {
    @Test func imperial() async {
        await withTestLocalization(.test) {
            let data: [(input: Quantity, output: String)] = [
                (.init(value: -100, style: .full), "-100 feet"),
                (.init(value: 0, style: .full), "0 feet"),
                (.init(value: 0.1, style: .full), "0.1 feet"),
                (.init(value: 1, style: .full), "1 foot"),
                (.init(value: 1.001, style: .full), "1.001 feet"),
                (.init(value: 1.0006, style: .full), "1.001 feet"),
                (.init(value: 10, style: .full), "10 feet"),
                (.init(value: 100, style: .full), "100 feet")
            ]

            for datum in data {
                await given {
                    datum
                } when: { datum in
                    quantity(datum.input)
                } then: { datum, result in
                    #expect(result == datum.output)
                }
            }
        }
    }

    func quantity(_ quantity: Quantity) -> String {
        Depth.Unit.feet.localization(for: .quantity(quantity.value, quantity.style))
    }
}

struct Quantity: Equatable {
    let value: Double
    let style: LocalizationStyle
}
