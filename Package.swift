// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "swift-git-version",
  platforms: [
    .macOS(.v12)
  ],
  products: [
    .library(name: "GitVersion", targets: ["GitVersion"]),
    .plugin(name: "BuildWithVersionPlugin", targets: ["BuildWithVersionPlugin"]),
    .plugin(name: "GenerateVersionPlugin", targets: ["GenerateVersionPlugin"]),
    .plugin(name: "UpdateVersionPlugin", targets: ["UpdateVersionPlugin"])
  ],
  dependencies: [
    .package(url: "https://github.com/m-housh/swift-shell-client.git", from: "0.1.0"),
    .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.2")
  ],
  targets: [
    .executableTarget(
      name: "git-version",
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
    .testTarget(
      name: "GitVersionTests",
      dependencies: ["GitVersion"]
    ),
    .plugin(
      name: "BuildWithVersionPlugin",
      capability: .buildTool(),
      dependencies: [
        "git-version"
      ]
    ),
    .plugin(
      name: "GenerateVersionPlugin",
      capability: .command(
        intent: .custom(
          verb: "generate-version",
          description: "Generates a version file in the given target."
        ),
        permissions: [
          .writeToPackageDirectory(reason: "Generate a version file in the target's directory.")
        ]
      ),
      dependencies: [
        "git-version"
      ]
    ),
    .plugin(
      name: "UpdateVersionPlugin",
      capability: .command(
        intent: .custom(
          verb: "update-version",
          description: "Updates a version file in the given target."
        ),
        permissions: [
          .writeToPackageDirectory(reason: "Update a version file in the target's directory.")
        ]
      ),
      dependencies: [
        "git-version"
      ]
    )
  ]
)
