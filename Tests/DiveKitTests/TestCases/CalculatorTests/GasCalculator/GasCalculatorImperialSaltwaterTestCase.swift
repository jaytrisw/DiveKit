import XCTest
@testable import DiveKit

final class GasCalculatorImperialSaltwaterTestCase: SystemUnderTestCase<GasCalculator> {

    var physicsCalculator: PhysicsCalculator!
    var expectedError: Error!

    override func createSUT() {
        sut = .init(.imperial, water: .salt)
        physicsCalculator = .init(.imperial, water: .salt)
    }
}
