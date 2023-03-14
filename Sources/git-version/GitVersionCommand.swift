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

