import Dependencies
import Foundation
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif
import XCTestDynamicOverlay

/// Represents the interactions with the file system.  It is able
/// to read from and write to files.
///
/// ```swift
///  @Dependency(\.fileClient) var fileClient
/// ```
///
public struct FileClient {

  /// Read the file contents from the given `URL` as `Data`.
  ///
  public private(set) var read: (URL) throws -> Data

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
  ///   - read: Read the file contents.
  ///   - write: Write the data to a file.
  public init(
    read: @escaping (URL) throws -> Data,
    write: @escaping (Data, URL) throws -> Void
  ) {
    self.read = read
    self.write = write
  }

  /// Read a file at the given path.
  ///
  /// - Parameters:
  ///   - path: The path to read the file at.
  public func read(path: String) throws -> Data {
    let url = try url(for: path)
    return try self.read(url)
  }

  /// Read the file as a string.
  ///
  /// - Parameters:
  ///   - url: The url for the file.
  public func readAsString(url: URL) throws -> String {
    let data = try read(url)
    return String(decoding: data, as: UTF8.self)
  }

  /// Read the file as a string
  ///
  /// - Parameters:
  ///   - path: The file path to read.
  public func readAsString(path: String) throws -> String {
    try self.readAsString(url: url(for: path))
  }

  /// Read the contents of a file and decode as the decodable type.
  ///
/// - Parameters:
  ///   - decodable: The type to decode.
  ///   - url: The file url.
  ///   - decoder: The decoder to use.
  public func read<D: Decodable>(
    _ decodable: D.Type,
    from url: URL,
    using decoder: JSONDecoder = .init()
  ) throws -> D {
    let data = try read(url)
    return try decoder.decode(D.self, from: data)
  }

  /// Read the contents of a file and decode as the decodable type.
  ///
  /// - Parameters:
  ///   - decodable: The type to decode.
  ///   - path: The file path.
  ///   - decoder: The decoder to use.
  public func read<D: Decodable>(
    _ decodable: D.Type,
    from path: String,
    using decoder: JSONDecoder = .init()
  ) throws -> D {
    let data = try read(path: path)
    return try decoder.decode(D.self, from: data)
  }

  /// Write the data to a file at the given path.
  ///
  /// - Parameters:
  ///   - data: The data to write to the file.
  ///   - path: The file path.
  public func write(data: Data, to path: String) throws {
    let url = try url(for: path)
    try self.write(data, url)
  }

  public func write(string: String, to url: URL) throws {
    try self.write(Data(string.utf8), url)
  }

  public func write(string: String, to path: String) throws {
    let url = try url(for: path)
    try self.write(string: string, to: url)
  }
}

extension FileClient: DependencyKey {

  /// A ``FileClient`` that does not do anything.
  public static let noop = FileClient.init(
    read: { _ in Data() },
    write: { _, _ in }
  )

  /// An `unimplemented` ``FileClient``.
  public static let testValue = FileClient(
    read: unimplemented("\(Self.self).read", placeholder: Data()),
    write: unimplemented("\(Self.self).write")
  )

  /// The live ``FileClient``
  public static let liveValue = FileClient(
    read: { try Data(contentsOf: $0) },
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

// MARK: - Overrides
extension FileClient {

  /// Override the data that get's returned when a `read` operation is called.
  ///
  /// This is useful in a testing context.
  ///
  /// - Parameters:
  ///   - data: The data to return when a read operation is called.
  public mutating func overrideRead(data: Data) {
    self.read = { _ in data }
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
