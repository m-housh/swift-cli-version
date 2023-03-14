import ArgumentParser
import Foundation

@main
struct GitVersionCommand: ParsableCommand {

  static var configuration: CommandConfiguration = .init(
    commandName: "git-version",
    version: VERSION ?? "0.0.0",
    subcommands: [
      Generate.self,
      Update.self
    ]
  )
}

struct SharedOptions: ParsableArguments {

  @Argument(help: "The target for the version file.")
  var target: String

  @Option(
    name: .customLong("filename"),
    help: "Specify the file name for the version file."
  )
  var fileName: String = "Version.swift"

  @Flag(name: .customLong("dry-run"))
  var dryRun: Bool = false
}
