import ArgumentParser
import Foundation
import GitVersion
import ShellClient

extension GitVersionCommand {

  struct Update: ParsableCommand {
    static var configuration: CommandConfiguration = .init(
      abstract: "Updates a version string to the git tag or git sha.",
      discussion: "This command can be interacted with directly outside of the plugin context."
    )

    @OptionGroup var shared: SharedOptions

    @Option(
      name: .customLong("git-directory"),
      help: "The git directory for the version."
    )
    var gitDirectory: String? = nil
    
    func run() throws {
      try withDependencies {
        $0.logger.logLevel = shared.verbose ? .debug : .info
        $0.fileClient = .liveValue
        $0.gitVersionClient = .liveValue
        $0.shellClient = .liveValue
      } operation: {
        @Dependency(\.gitVersionClient) var gitVersion
        @Dependency(\.fileClient) var fileClient
        @Dependency(\.logger) var logger
        @Dependency(\.shellClient) var shell

        let targetUrl = parseTarget(shared.target)
        let fileUrl = targetUrl
          .appendingPathComponent(shared.fileName)

        let fileString = fileUrl.fileString()

        let currentVersion = try gitVersion.currentVersion(in: gitDirectory)

        let fileContents = template
          .replacingOccurrences(of: "nil", with: "\"\(currentVersion)\"")

        if !shared.dryRun {
          try fileClient.write(string: fileContents, to: fileUrl)
          logger.info("Updated version file: \(fileString)")
        } else {
          logger.info("Would update file contents to:")
          logger.info("\(fileContents)")
        }
      }
    }
  }
}

fileprivate enum UpdateError: Error {
  case versionFileDoesNotExist(path: String)
}
