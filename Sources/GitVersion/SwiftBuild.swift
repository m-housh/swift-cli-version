import Dependencies
import Foundation
import ShellClient

extension ShellCommand {

  /// Create a ``ShellCommand`` instance that's a wrapper for the `swift build`
  /// command.
  ///
  /// - Parameters:
  ///   - build: The build command to use.
  public static func swiftBuild(_ build: SwiftBuild) -> Self {
    build.command
  }
}

/// A wrapper around the `swift build` command.  This allows you to build a project from
/// swift.
///
public struct SwiftBuild {
  @Dependency(\.logger) var logger
  @Dependency(\.shellClient) var shell

  /// Represents the default arguments for the build command.
  public static let defaults: [Argument] = [
    .disableSandBox,
    .xSwiftC("-cross-module-optimization")
  ]

  /// The arguments for the build command.
  public let arguments: [Argument]

  /// The configuration for the build command.
  public let configuration: Configuration

  /// Create a ``SwiftBuild`` instance for the ``Configuration/debug`` configuration.
  ///
  /// - Parameters:
  ///   - arguments: The arguments for the `swift build` command.
  public static func debug(_ arguments: [Argument] = Self.defaults) -> Self {
    .init(configuration: .debug, arguments: arguments)
  }

  /// Create a ``SwiftBuild`` instance for the ``Configuration/release`` configuration.
  ///
  /// - Parameters:
  ///   - arguments: The arguments for the `swift build` command.
  public static func release(_ arguments: [Argument] = Self.defaults) -> Self {
    .init(configuration: .release, arguments: arguments)
  }

  internal init(
    configuration: Configuration = .debug,
    arguments: [Argument] = Self.defaults
  ) {
    self.arguments = arguments
    self.configuration = configuration
  }

  internal var command: ShellCommand {
    .init(
      shell: .env,
      [
        "swift",
        "build",
        "--configuration",
        "\(configuration)"
      ]
      + arguments.strings
    )
  }

  internal func run() throws {
    logger.info("\("Building.".blue)")

    try withDependencies {
      $0.logger.logLevel = .debug
    } operation: {
      try shell.foreground(command)
    }
  }

  /// Represents an argument for the ``SwiftBuild`` command.
  public enum Argument {
    /// Disable the sandbox.
    case disableSandBox
    /// Pass a string through to the `swift build` command.
    case custom([String])
    /// Pass an `-Xswiftc` compiler flag through to the `swift build` command.
    case xSwiftC(String)
  }

  /// Represents the configuration for the ``SwiftBuild`` command.
  public enum Configuration: String, CustomStringConvertible, CaseIterable {
    /// The debug configuration.
    case debug
    /// The release configuration.
    case release
    public var description: String { rawValue }
  }
}

extension ShellClient {
  /// Replace nil in the given file path and then run the given closure.
  ///
  /// > Note: The file contents will be reset back to nil after the closure operation.
  ///
  /// - Parameters:
  ///   - filePath: The file path to replace nil in.
  ///   - workingDirectory: Customize the working directory for the command.
  ///   - build: The swift builder to use.
  public func replacingNilWithVersionString(
    in filePath: String,
    from workingDirectory: String? = nil,
    _ closure: @escaping () throws -> Void
  ) throws {
    @Dependency(\.fileClient) var fileClient: FileClient
    @Dependency(\.gitVersionClient) var gitClient: GitVersionClient

    let currentVersion = try gitClient.currentVersion(in: workingDirectory)
    let originalContents = try fileClient.readAsString(path: filePath)

    let updatedContents = originalContents
      .replacingOccurrences(of: "nil", with: "\"\(currentVersion)\"")
    try fileClient.write(string: updatedContents, to: filePath)
    defer { try! fileClient.write(string: originalContents, to: filePath) }

    try closure()
  }

  /// Replace nil in the given file path and then build the project, using the
  /// given builder.
  ///
  /// > Note: The file contents will be reset back to nil after the build operation.
  ///
  /// - Parameters:
  ///   - filePath: The file path to replace nil in.
  ///   - workingDirectory: Customize the working directory for the command.
  ///   - build: The swift builder to use.
  public func replacingNilWithVersionString(
    in filePath: String,
    from workingDirectory: String? = nil,
    build: SwiftBuild
  ) throws {
    try replacingNilWithVersionString(
      in: filePath,
      from: workingDirectory,
      build.run
    )
  }
}

fileprivate extension Array where Element == SwiftBuild.Argument {

  var strings: [String] {
    reduce(into: [String]()) { current, argument in
      switch argument {
      case .disableSandBox:
        current.append("--disable-sandbox")
      case .custom(let strings):
        current += strings
      case .xSwiftC(let value):
        current += ["-Xswiftc", value]
      }
    }
  }
}
