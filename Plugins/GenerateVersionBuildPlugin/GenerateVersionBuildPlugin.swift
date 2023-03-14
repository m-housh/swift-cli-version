import Foundation
import PackagePlugin

@main
struct GenerateVersionBuildPlugin: BuildToolPlugin {
  func createBuildCommands(
    context: PackagePlugin.PluginContext,
    target: PackagePlugin.Target
  ) async throws -> [PackagePlugin.Command] {
    guard let target = target as? SourceModuleTarget else { return [] }
    let outputPath = context.pluginWorkDirectory
    let tool = try context.tool(named: "git-version")
    let outputFile = outputPath.appending(subpath: "Version.swift")
    return [
      .buildCommand(
        displayName: "Build With Version",
        executable: tool.path,
        arguments: ["generate", "\(target.name)"],
        environment: [:],
        inputFiles: target.sourceFiles.map(\.path),
        outputFiles: [outputFile]
      )
    ]
  }
}