import Foundation
import PackagePlugin

@main
struct GitVersionBuildPlugin: BuildToolPlugin {

  func createBuildCommands(
    context: PackagePlugin.PluginContext,
    target: PackagePlugin.Target
  ) async throws -> [PackagePlugin.Command] {

    guard let target = target as? SourceModuleTarget else { return [] }
    let buildTool = try context.tool(named: "git-version-builder")

    let outputDir = context.pluginWorkDirectory
      .appending(subpath: target.name)

    try FileManager.default
      .createDirectory(atPath: outputDir.string, withIntermediateDirectories: true)

    let inputFiles = target.sourceFiles
      .filter({ $0.type == .source && $0.path.stem == "Version" })
      .map(\.path)

    guard inputFiles.count == 1 else { return [] }

    let outputFile = outputDir.appending(subpath: "Version.generated.swift")

    print("Input swift files: \(inputFiles)")

//    let originalContents = try String(contentsOfFile: inputFiles.first!.string)
//    let updatedContents = originalContents.replacingOccurrences(of: "nil", with: "\"0.1.123\"")
//
//    print("Updated contents")
//    print(updatedContents)

    // this fails.
    return [
      .buildCommand(
        displayName: "Git Version Build Plugin",
        executable: buildTool.path,
        arguments: [
          inputFiles.first!,
          outputFile.string
        ]
//        ,
//        outputFiles: [outputFile]
      )
    ]
  }
}
