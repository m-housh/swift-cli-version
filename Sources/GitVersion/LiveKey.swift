import Foundation
import ShellClient

extension GitVersionClient: DependencyKey {
  
  public static var liveValue: GitVersionClient {
    .init(currentVersion: { gitDirectory in
      try GitVersion(workingDirectory: gitDirectory).currentVersion()
    })
  }
}

fileprivate struct GitVersion {
  @Dependency(\.logger) var logger: Logger
  @Dependency(\.shellClient) var shell: ShellClient
  
  let workingDirectory: String?
  
  func currentVersion() throws -> String {
    logger.debug("\("Fetching current version".bold)")
    do {
      logger.debug("Checking for tag.")
      return try run(command: command(for: .describe))
    } catch {
      logger.debug("\("No tag found, deferring to branch & git sha".red)")
      let branch = try run(command: command(for: .branch))
      let commit = try run(command: command(for: .commit))
      return "\(branch) \(commit)"
    }
  }
  
  private func command(for argument: VersionArgs) -> ShellCommand {
    .init(
      shell: .env,
      environment: nil,
      in: workingDirectory,
      arguments: argument.arguments
    )
  }
}

fileprivate extension GitVersion {
  func run(command: ShellCommand) throws -> String {
    try shell.background(command, trimmingCharactersIn: .whitespacesAndNewlines)
  }
  
  enum VersionArgs {
    case branch
    case commit
    case describe
    
    var arguments: [Args] {
      switch self {
      case .branch:
        return [.git, .symbolicRef, .quiet, .short, .head]
      case .commit:
        return [.git, .revParse, .short, .head]
      case .describe:
        return [.git, .describe, .tags, .exactMatch]
      }
    }
    
    enum Args: String, CustomStringConvertible {
      case git
      case describe
      case tags = "--tags"
      case exactMatch = "--exact-match"
      case quiet = "--quiet"
      case symbolicRef = "symbolic-ref"
      case revParse = "rev-parse"
      case short = "--short"
      case head = "HEAD"
    }
    
  }
}

fileprivate extension RawRepresentable where RawValue == String, Self: CustomStringConvertible {
  var description: String { rawValue }
}
