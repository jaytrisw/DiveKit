import XCTest

class ThrowingMethodUnderTestCase<SUT, Input, Output>: SystemUnderTestCase<SUT> {

    var data: [Data]!
    var mut: ((Input) throws -> Output)!

    override func tearDown() {
        sut = .none
        mut = .none
        data = .none

        super.tearDown()
    }

    struct Data {
        var input: Input
        var output: Output
    }
}
