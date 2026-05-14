import Foundation
@testable import DiveKit

open class LocalizationSystemUnderTestCase<SUT>: SystemUnderTestCase<SUT> {
    private var resolver: LocalizationResolver!
    private var locale: Locale!

    override open func setUp() {
        resolver = Localization.standard.resolver
        locale = Localization.standard.locale
        Localization.standard.set(.diveKitTestCatalog)
        Localization.standard.set(Locale(identifier: "en_US"))

        super.setUp()
    }

    override open func tearDown() {
        super.tearDown()

        Localization.standard.set(resolver)
        Localization.standard.set(locale)
        resolver = .none
        locale = .none
    }
}

open class LocalizationThrowingMethodUnderTestCase<SUT, Input: Equatable, Output: Equatable>:
    ThrowingMethodUnderTestCase<SUT, Input, Output> {
    private var resolver: LocalizationResolver!
    private var locale: Locale!

    override open func setUp() {
        resolver = Localization.standard.resolver
        locale = Localization.standard.locale
        Localization.standard.set(.diveKitTestCatalog)
        Localization.standard.set(Locale(identifier: "en_US"))

        super.setUp()
    }

    override open func tearDown() {
        super.tearDown()

        Localization.standard.set(resolver)
        Localization.standard.set(locale)
        resolver = .none
        locale = .none
    }
}
