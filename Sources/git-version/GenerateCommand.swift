import ArgumentParser
import Dependencies
import Foundation
import GitVersion
import ShellClient

extension GitVersionCommand {

  struct Generate: ParsableCommand {
    static var configuration: CommandConfiguration = .init(
      abstract: "Generates a version file in a command line tool that can be set via the git tag or git sha."
    )

    @OptionGroup var shared: SharedOptions

    func run() throws {
      @Dependency(\.logger) var logger: Logger
      @Dependency(\.fileClient) var fileClient

      let targetUrl = parseTarget(shared.target)
      let fileUrl = targetUrl.appendingPathComponent(shared.fileName)

      let fileString = fileUrl.fileString()

      guard !FileManager.default.fileExists(atPath: fileUrl.absoluteString) else {
        logger.info("File already exists at path.")
        throw GenerationError.fileExists(path: fileString)
      }

      if !shared.dryRun {
        try fileClient.write(string: template, to: fileUrl)
        logger.info("Generated file at: \(fileString)")
      } else {
        logger.info("Would generate file at: \(fileString)")
      }

    }
  }
}

fileprivate enum GenerationError: Error {
  case fileExists(path: String)
}

fileprivate let template = """
// Do not set this variable, it is set during the build process.
let VERSION: String? = nil

"""