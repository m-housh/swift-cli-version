# swift-git-version

A swift package that exposes some helpers to set the version of a command line tool to the
git tag or the git sha, if a tag is not set for the current commit.

## Usage

You can use this in your command line tool via the swift package manager.

```swift
let package = Package(
  ...
  dependencies: [
    .package(url: "https://github.com/m-housh/swift-git-version.git", from: "0.1.0")
  ],
  targets: [
    .executableTarget(
      name: "my-executable",
      dependencies: [
        ...
      ]
    ),
    .executableTarget(
      name: "my-executable-builder",
      dependencies: [
        .product(name: "GitVersion", package: "swift-git-version")
      ]
    ),
  ]
)
```

Inside of your executable (`my-executable`) in the above example, you will want to create
a file that contains your version variable.

```swift
// Do not set this variable, it is set by the build script.

let VERSION: String? = nil
```

