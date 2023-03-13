import PackagePlugin
import Foundation

@main
struct GitVersionPlugin: CommandPlugin {

  func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {
    let tool = try context.tool(named: "build-example")
    let url = URL(fileURLWithPath: tool.path.string)

    for target in context.package.targets {
      guard let target = target as? SourceModuleTarget else { continue }
      let process = Process()
      process.executableURL = url
      try process.run()
      process.waitUntilExit()

      if process.terminationReason == .exit && process.terminationStatus == 0 {
        print("Done building in: \(target.directory)")
      } else {
        let problem = "\(process.terminationReason): \(process.terminationStatus)"
        Diagnostics.error("\(problem)")
      }
    }
  }


//  func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
//    guard let target = target.sourceModule else { return [] }
//    let tool = try context.tool(named: "build-example")
//
//
//  }
}
