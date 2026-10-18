import Testing
@testable import DiveKit
import DiveKitTestSupport

@Suite
struct DecimalRepresentableLiteralTests {
    @Test func floatLiteralKeepsDoublePrecision() async {
        await given {
            (depth: 2.3 as Depth, partialPressure: 1.4 as PartialPressure<Oxygen>, minutes: 0.1 as Minutes)
        } when: { input in
            (depth: input.depth.value, partialPressure: input.partialPressure.value, minutes: input.minutes.value)
        } then: { _, values in
            #expect(values.depth == 2.3)
            #expect(values.partialPressure == 1.4)
            #expect(values.minutes == 0.1)
        }
    }

    @Test func integerLiteral() async {
        await given {
            33 as Depth
        } when: { sut in
            sut.value
        } then: { _, value in
            #expect(value == 33)
        }
    }
}
