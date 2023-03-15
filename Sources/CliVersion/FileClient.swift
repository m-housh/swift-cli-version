import Dependencies
import Foundation
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif
import XCTestDynamicOverlay

/// Represents the interactions with the file system.  It is able
/// to read from and write to files.
///
///
/// ```swift
///  @Dependency(\.fileClient) var fileClient
/// ```
///
public struct FileClient {

  /// Write `Data` to a file `URL`.
  public private(set) var write: (Data, URL) throws -> Void

  /// Create a new ``GitVersion/FileClient`` instance.
  ///
  /// This is generally not interacted with directly, instead access as a dependency.
  ///
  ///```swift
  /// @Dependency(\.fileClient) var fileClient
  ///```
  ///
  /// - Parameters:
  ///   - write: Write the data to a file.
  public init(
    write: @escaping (Data, URL) throws -> Void
  ) {
    self.write = write
  }

  /// Write's the the string to a  file path.
  ///
  /// - Parameters:
  ///   - string: The string to write to the file.
  ///   - path: The file path.
  public func write(string: String, to path: String) throws {
    let url = try url(for: path)
    try self.write(string: string, to: url)
  }

  /// Write's the the string to a  file path.
  ///
  /// - Parameters:
  ///   - string: The string to write to the file.
  ///   - url: The file url.
  public func write(string: String, to url: URL) throws {
    try self.write(Data(string.utf8), url)
  }
}

extension FileClient: DependencyKey {

  /// A ``FileClient`` that does not do anything.
  public static let noop = FileClient.init(
    write: { _, _ in }
  )

  /// An `unimplemented` ``FileClient``.
  public static let testValue = FileClient(
    write: unimplemented("\(Self.self).write")
  )

  /// The live ``FileClient``
  public static let liveValue = FileClient(
    write: { try $0.write(to: $1, options: .atomic) }
  )

}

extension DependencyValues {

  /// Access a basic ``FileClient`` that can read / write data to the file system.
  ///
  public var fileClient: FileClient {
    get { self[FileClient.self] }
    set { self[FileClient.self] = newValue }
  }
}

// MARK: - Private
fileprivate func url(for path: String) throws -> URL {
  #if os(Linux)
    return URL(fileURLWithPath: path)
  #else
    if #available(macOS 13.0, *) {
      return URL(filePath: path)
    } else {
      // Fallback on earlier versions
      return URL(fileURLWithPath: path)
    }
  #endif
}
