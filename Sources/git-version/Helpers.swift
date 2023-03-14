import Foundation

func parseTarget(_ target: String) -> URL {
  let url = URL(fileURLWithPath: target)
  let urlTest = url
    .deletingLastPathComponent()

  guard urlTest.lastPathComponent == "Sources" else {
    return URL(fileURLWithPath: "Sources")
      .appendingPathComponent(target)
  }
  return url
}

extension URL {
  func fileString() -> String {
    self.absoluteString
      .replacingOccurrences(of: "file://", with: "")
  }
}
