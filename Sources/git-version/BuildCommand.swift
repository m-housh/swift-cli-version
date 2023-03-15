import ArgumentParser
import Foundation
import GitVersion
import ShellClient

extension GitVersionCommand {
  struct Build: ParsableCommand {
    static var configuration: CommandConfiguration = .init(
      abstract: "Used for the build with version plugin."
    )
    
//    @OptionGroup var shared: SharedOptions
    
    @Argument(help: "The output file path.")
    var outputPath: String
    
    @Option(
      name: .customLong("git-directory"),
      help: "The git directory for the version."
    )
    var gitDirectory: String
    
    func run() throws {
      try withDependencies {
        $0.logger.logLevel = .debug
        $0.fileClient = .liveValue
        $0.gitVersionClient = .liveValue
      } operation: {
        @Dependency(\.gitVersionClient) var gitVersion
        @Dependency(\.fileClient) var fileClient
        @Dependency(\.logger) var logger: Logger

        logger.info("Building with git-directory: \(gitDirectory)")
        
        let fileUrl = URL(fileURLWithPath: outputPath)
        let fileString = fileUrl.fileString()
        logger.info("File Url: \(fileString)")

        let currentVersion = try gitVersion.currentVersion(in: gitDirectory)

        let fileContents = template
          .replacingOccurrences(of: "nil", with: "\"\(currentVersion)\"")
        
        try fileClient.write(string: fileContents, to: fileUrl)
        logger.info("Updated version file: \(fileString)")
      }
    }
  }
}

