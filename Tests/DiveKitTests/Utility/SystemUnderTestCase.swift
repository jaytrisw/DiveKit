import XCTest

open class SystemUnderTestCase<SUT>: XCTestCase {

    public var sut: SUT!

    override open func setUp() {
        super.setUp()

        createSUT()
    }

    override open func tearDown() {
        sut = .none

        super.tearDown()
    }

    open func createSUT() {}
}
