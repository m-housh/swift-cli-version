// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "swift-git-version",
  platforms: [
    .macOS(.v10_15)
  ],
  products: [
    .library(name: "GitVersion", targets: ["GitVersion"])
  ],
  dependencies: [
    .package(url: "https://github.com/m-housh/swift-shell-client.git", from: "0.1.0"),
    .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.2"),
  ],
  targets: [
    .target(
      name: "GitVersion",
      dependencies: [
        .product(name: "ShellClient", package: "swift-shell-client")
      ]
    ),
    .executableTarget(
      name: "build-example",
      dependencies: [
        "GitVersion"
      ]
    ),
    .executableTarget(
      name: "example",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "ShellClient", package: "swift-shell-client")
      ]
    ),
    .testTarget(
      name: "GitVersionTests",
      dependencies: ["GitVersion"]
    ),
  ]
)
