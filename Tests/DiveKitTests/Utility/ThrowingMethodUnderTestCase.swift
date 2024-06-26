import XCTest

open class ThrowingMethodUnderTestCase<SUT, Input: Equatable, Output: Equatable>: SystemUnderTestCase<SUT> {

    public var data: [Data]!
    public var mut: ((Input) throws -> Output)!

    override open func tearDown() {
        sut = .none
        mut = .none
        data = .none

        super.tearDown()
    }

    public struct Data {
        public let input: Input
        public let output: Output

        public init(_ input: Input, output: Output) {
            self.input = input
            self.output = output
        }
    }
}
