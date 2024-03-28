import XCTest

class SystemUnderTestCase<SUT>: XCTestCase {

    var sut: SUT!

    override func setUp() {
        super.setUp()

        createSUT()
    }

    override func tearDown() {
        sut = .none

        super.tearDown()
    }

    func createSUT() {}
}
