# Getting Started

Learn how to integrate the plugins into your project

## Overview

Use the plugins by including as a package to your project and declaring in the `plugins` section of
your target.

```swift
let package = Package(
  ...,
  dependencies: [
    ...,
    .package(url: "https://github.com/m-housh/swift-git-version.git", from: "0.1.0")
  ],
  targets: [
    .executableTarget(
      name: "<target name>",
      dependencies: [...],
      plugins: [ 
        .plugin(name: "BuildWithVersionPlugin", package: "swift-git-version")
      ]
    )
  ]
)
```

The above example uses the build tool plugin.  The `BuildWithVersionPlugin` will give you access
to a `VERSION` variable in your project that you can use to supply the version of the tool.

### Example

```swift
import ArgumentParser

@main
struct MyCliTool: ParsableCommand { 
  static let configuration = CommandConfiguration(
    abstract: "My awesome cli tool",
    version: VERSION
  )

  func run() throws { 
    print("Version: \(VERSION)")
  }
}
```

You will have access to the `VERSION` string variable even though it is not declared in your source
files.
