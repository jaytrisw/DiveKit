import TestUtility
@testable import DiveKit

final class GasCalculatorImperialSaltwaterTestCase: SystemUnderTestCase<GasCalculator> {

    var physicsCalculator: PhysicsCalculator!

    override func createSUT() {
        sut = .init(.imperial, water: .salt)
        physicsCalculator = .init(.imperial, water: .salt)
    }
}
