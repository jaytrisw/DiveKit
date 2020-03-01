import XCTest
@testable import DiveKit

final class DiveKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(DiveKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
