import ArgumentParser
import Foundation
import GitVersion
import ShellClient

extension GitVersionCommand {

  struct Update: ParsableCommand {
    static var configuration: CommandConfiguration = .init(
      abstract: "Updates a version string to the git tag or git sha."
    )

    @OptionGroup var shared: SharedOptions

    @Option(
      name: .customLong("git-directory"),
      help: "The git directory for the version."
    )
    var gitDirectory: String? = nil
    
    func run() throws {
      @Dependency(\.logger) var logger: Logger
      @Dependency(\.fileClient) var fileClient: FileClient
      @Dependency(\.gitVersionClient) var gitVersion
      @Dependency(\.shellClient) var shell

      let targetUrl = parseTarget(shared.target)
      let fileUrl = targetUrl.appendingPathComponent(shared.fileName)
      let fileString = fileUrl.fileString()

//      guard FileManager.default.fileExists(atPath: fileUrl.absoluteString) else {
//        logger.info("Version file does not exist.")
//        throw UpdateError.versionFileDoesNotExist(path: fileString)
//      }

      let currentVersion = try gitVersion.currentVersion()
      let cwd = FileManager.default.currentDirectoryPath
      logger.info("CWD: \(cwd)")
      logger.info("Git version: \(currentVersion)")

      var updatedContents: String = ""
      try withDependencies({
        $0.logger.logLevel = .debug
      }, operation: {
        try shell.replacingNilWithVersionString(
          in: fileString
//          from: gitDirectory
        ) {
          updatedContents = $0
        }
      })

      if !shared.dryRun {
        try fileClient.write(string: updatedContents, to: fileUrl)
        logger.info("Updated version file: \(fileString)")
      } else {
        logger.info("Would update file contents to:")
        logger.info("\(updatedContents)")
      }
    }
  }
}

fileprivate enum UpdateError: Error {
  case versionFileDoesNotExist(path: String)
}
