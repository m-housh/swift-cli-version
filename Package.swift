// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "swift-git-version",
  platforms: [
    .macOS(.v10_15)
  ],
  dependencies: [
    .package(url: "https://github.com/m-housh/swift-shell-client.git", from: "0.1.0")
  ],
  targets: [
    .target(
      name: "GitVersion",
      dependencies: [
        .product(name: "ShellClient", package: "swift-shell-client")
      ]
    ),
    .executableTarget(
      name: "swift-git-version",
      dependencies: [
        "GitVersion"
      ]
    ),
    .testTarget(
      name: "swift-git-versionTests",
      dependencies: ["swift-git-version"]
    ),
  ]
)
