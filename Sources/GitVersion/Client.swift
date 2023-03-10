import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import ShellClient
import XCTestDynamicOverlay

public struct GitVersionClient {
  private var currentVersion: (String?) throws -> String
  
  public init(currentVersion: @escaping (String?) throws -> String) {
    self.currentVersion = currentVersion
  }
  
  public func currentVersion(in gitDirectory: String? = nil) throws -> String {
    try self.currentVersion(gitDirectory)
  }
  
  public mutating func override(with version: String) {
    self.currentVersion = { _ in version }
  }
}

extension GitVersionClient: TestDependencyKey {
 
  public static let testValue = GitVersionClient(
    currentVersion: unimplemented("\(Self.self).currentVersion", placeholder: "")
  )
  
}

extension DependencyValues {
  
  public var gitVersionClient: GitVersionClient {
    get { self[GitVersionClient.self] }
    set { self[GitVersionClient.self] = newValue }
  }
}
