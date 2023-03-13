import Foundation
import GitVersion
import ShellClient

/// Shows the intended use-case for building a command line tool that set's the version
/// based on the tag in the git worktree.

@main
public struct Build {
  public static func main() throws {
    @Dependency(\.shellClient) var shell: ShellClient

    try shell.replacingNilWithVersionString(
      in: "Sources/example/Version.swift",
      build: SwiftBuild.release()
    )
  }
}
