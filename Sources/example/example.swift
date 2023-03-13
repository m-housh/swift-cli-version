import ArgumentParser
import ShellClient

/// An example of using the git version client with a command line tool
/// The ``VERSION`` variable get's set during the build process.
@main
public struct Example: ParsableCommand {

  public static let configuration: CommandConfiguration = .init(
    abstract: "An example of using the `GitVersion` command to set the version for a command line app.",
    version: VERSION ?? "0.0.0"
  )

  public init() { }

  public func run() throws {
    @Dependency(\.logger) var logger: Logger

    let version = (VERSION ?? "0.0.0").blue
    logger.info("Version: \(version)")
  }

}
