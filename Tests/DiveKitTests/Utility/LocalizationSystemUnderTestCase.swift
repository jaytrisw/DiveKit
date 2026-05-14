@testable import DiveKit

open class LocalizationSystemUnderTestCase<SUT>: SystemUnderTestCase<SUT> {
    private var resolver: LocalizationResolver!

    override open func setUp() {
        resolver = Localization.standard.resolver
        Localization.standard.set(.diveKitTestCatalog)

        super.setUp()
    }

    override open func tearDown() {
        super.tearDown()

        Localization.standard.set(resolver)
        resolver = .none
    }
}

open class LocalizationThrowingMethodUnderTestCase<SUT, Input: Equatable, Output: Equatable>:
    ThrowingMethodUnderTestCase<SUT, Input, Output> {
    private var resolver: LocalizationResolver!

    override open func setUp() {
        resolver = Localization.standard.resolver
        Localization.standard.set(.diveKitTestCatalog)

        super.setUp()
    }

    override open func tearDown() {
        super.tearDown()

        Localization.standard.set(resolver)
        resolver = .none
    }
}
