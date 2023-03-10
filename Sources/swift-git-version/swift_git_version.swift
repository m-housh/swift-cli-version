import GitVersion
import ShellClient

// An example of using the git version client.

@main
public struct swift_git_version {
  public static func main() {
    @Dependency(\.logger) var logger
    @Dependency(\.gitVersionClient) var client
    
    do {
      let version = try client.currentVersion()
      logger.info("Version: \(version.blue)")
    } catch {
      logger.info("\("Oops, something went wrong".red)")
    }
  }
}
