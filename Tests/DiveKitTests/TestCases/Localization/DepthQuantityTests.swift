import Testing
@testable import DiveKit
import DiveKitTestSupport

@Suite(.tags(.localization))
struct DepthQuantityTests {
    @Test(arguments: [
        (Quantity(value: -100, style: .full), "-100 feet"),
        (Quantity(value: 0, style: .full), "0 feet"),
        (Quantity(value: 0.1, style: .full), "0.1 feet"),
        (Quantity(value: 1, style: .full), "1 foot"),
        (Quantity(value: 1.001, style: .full), "1.001 feet"),
        (Quantity(value: 1.0006, style: .full), "1.001 feet"),
        (Quantity(value: 10, style: .full), "10 feet"),
        (Quantity(value: 100, style: .full), "100 feet")])
    func imperial(input: Quantity, output: String) async {
        await withTestLocalization(.test) {
            await given {
                input
            } when: { input in
                quantity(input)
            } then: { _, result in
                #expect(result == output)
            }
        }
    }

    func quantity(_ quantity: Quantity) -> String {
        Depth.Unit.feet.localization(for: .quantity(quantity.value, quantity.style))
    }
}

struct Quantity: Equatable, Sendable {
    let value: Double
    let style: LocalizationStyle
}
