import XCTest
import GitVersion
import ShellClient

final class GitVersionTests: XCTestCase {

  func test_overrides_work() throws {
    try withDependencies {
      $0.gitVersionClient.override(with: "blob")
    } operation: {
      @Dependency(\.gitVersionClient) var versionClient

      let version = try versionClient.currentVersion()
      XCTAssertEqual(version, "blob")
    }
  }

  func test_live() throws {
    try withDependencies({
      $0.logger.logLevel = .debug
      $0.logger = .liveValue
      $0.shellClient = .liveValue
      $0.gitVersionClient = .liveValue
    }, operation: {

      @Dependency(\.gitVersionClient) var versionClient

      let gitDir = URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()

      let version = try versionClient.currentVersion(in: gitDir.absoluteString)
      print("VERSION: \(version)")
      // can't really have a predictable result for the live client.
      XCTAssertNotEqual(version, "blob")

      let other = try versionClient.currentVersion()
      XCTAssertEqual(version, other)

    })
  }
}
