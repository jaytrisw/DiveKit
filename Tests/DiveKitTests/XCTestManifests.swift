import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DiveKitTests.allTests),
        testCase(DKEnrichedAirTests.allTests)
    ]
}
#endif
