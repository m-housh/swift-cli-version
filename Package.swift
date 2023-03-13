// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "swift-git-version",
  platforms: [
    .macOS(.v12)
  ],
  products: [
    .library(name: "GitVersion", targets: ["GitVersion"]),
    .plugin(name: "GitVersionBuildPlugin", targets: ["GitVersionBuildPlugin"]),
  ],
  dependencies: [
    .package(url: "https://github.com/m-housh/swift-shell-client.git", from: "0.1.0"),
    .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.2"),
  ],
  targets: [
    .executableTarget(
      name: "git-version-builder",
      dependencies: [
        "GitVersion",
        .product(name: "ArgumentParser", package: "swift-argument-parser")
      ]
    ),
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
      ,
      plugins: [
        .plugin(name: "GitVersionBuildPlugin")
      ]
    ),
    .testTarget(
      name: "GitVersionTests",
      dependencies: ["GitVersion"]
    ),
//    .plugin(
//      name: "GitVersionPlugin",
//      capability: .command(
//        intent: .custom(verb: "build-with-version", description: "Build a command line tool with git version."),
//        permissions: [
//          .writeToPackageDirectory(reason: "This command builds a command line tool with a git version.")
//        ]
//      ),
//      dependencies: [
//        "build-example"
//      ]
//    ),
    .plugin(
      name: "GitVersionBuildPlugin",
      capability: .buildTool(),
      dependencies: [
        "git-version-builder"
      ]
    )
  ]
)
