import Foundation
import GitVersion
import ShellClient

/// Shows the intended use-case for building a command line tool that set's the version
/// based on the tag in the git worktree.

@main
public struct Build {
  public static func main() throws {
    @Dependency(\.shellClient) var shell: ShellClient

    let gitDir = URL(fileURLWithPath: #file)
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .deletingLastPathComponent()

    try withDependencies {
      $0.gitVersionClient = .liveValue
      $0.logger.logLevel = .debug
    } operation: {
      try shell.replacingNilWithVersionString(
        in: "Sources/example/Version.swift",
        from: gitDir.absoluteString,
        build: SwiftBuild.release()
      )
    }
  }
}
