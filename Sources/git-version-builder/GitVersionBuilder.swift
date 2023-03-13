import ArgumentParser
import Dependencies
import GitVersion
import ShellClient

@main
public struct GitVersionBuilder: AsyncParsableCommand {

  public init() { }

  @Argument
  var input: String

  @Argument
  var output: String

  public func run() async throws {
    @Dependency(\.logger) var logger
    @Dependency(\.fileClient) var fileClient
    @Dependency(\.shellClient) var shell: ShellClient

    logger.debug("Building with input file: \(input)")
    logger.debug("Output file: \(output)")

    try shell.replacingNilWithVersionString(
      in: input
    ) { update in
      logger.debug("Updating with:\n\(update)")
      try fileClient.write(string: update, to: output)
    }

  }
}

