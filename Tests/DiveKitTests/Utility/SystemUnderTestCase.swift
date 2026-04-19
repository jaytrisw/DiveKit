import Testing

class SystemUnderTestCase<SUT> {

    public var sut: SUT!

    init() {
        createSUT()
    }

    func createSUT() {}
}
