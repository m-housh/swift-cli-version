import XCTest
@testable import swift_git_version

final class swift_git_versionTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swift_git_version().text, "Hello, World!")
    }
}
