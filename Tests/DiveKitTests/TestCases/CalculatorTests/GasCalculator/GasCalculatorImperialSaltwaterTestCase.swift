import Testing
@testable import DiveKit

@Suite("Gas Calculator", .tags(.gasCalculator))
final class GasCalculatorImperialSaltwaterTestCase {

    let sut: GasCalculator
    let physicsCalculator: PhysicsCalculator
    var expectedError: Error!

    init() {
        sut = .init(.imperial, water: .salt)
        physicsCalculator = .init(.imperial, water: .salt)
    }
}
