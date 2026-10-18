import Testing
@testable import DiveKit
import DiveKitTestSupport

@Suite("Gas Calculator", .tags(.gasCalculator, .saltWater, .imperial))
final class GasCalculatorImperialSaltwaterTests {

    let sut: GasCalculator
    let physicsCalculator: PhysicsCalculator

    init() {
        sut = .init(.imperial, water: .salt)
        physicsCalculator = .init(.imperial, water: .salt)
    }
}
