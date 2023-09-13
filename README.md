# swift-cli-version
[![CI](https://github.com/m-housh/swift-cli-version/actions/workflows/ci.yml/badge.svg)](https://github.com/m-housh/swift-cli-version/actions/workflows/ci.yml)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fm-housh%2Fswift-cli-version%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/m-housh/swift-cli-version)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fm-housh%2Fswift-cli-version%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/m-housh/swift-cli-version)

A swift package that exposes some plugins to set the version of a command line tool to the
git tag or the git sha, if a tag is not set for the current commit.

- [Github Repo](https://github.com/m-housh/swift-cli-version)
- [Documentation](https://m-housh.github.io/swift-cli-version/documentation/cliversion)

## Overview

Use the plugins by including as a package to your project and declaring in the `plugins` section of
your target.

> Note: You must use swift-tools version 5.6 or greater for package plugins and
> target `macOS(.v10_15)` or greater.

```swift
// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  platforms:[.macOS(.v10_15)],
  dependencies: [
    ...,
    .package(url: "https://github.com/m-housh/swift-cli-version.git", from: "0.1.0")
  ],
  targets: [
    .executableTarget(
      name: "<target name>",
      dependencies: [...],
      plugins: [ 
        .plugin(name: "BuildWithVersionPlugin", package: "swift-cli-version")
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

After you enable the plugin, you will have access to the `VERSION` string variable even though it is 
not declared in your source files.

## Documentation

You can view the latest [documentation here](https://m-housh.github.io/swift-cli-version/documentation/cliversion).

## Dependencies

This project relys on the following dependencies:

- [swift-argument-parser](https://github.com/apple/swift-argument-parser)
- [swift-dependencies](https://github.com/pointfreeco/swift-dependencies)
- [swift-shell-client](https://github.com/m-housh/swift-shell-client)
