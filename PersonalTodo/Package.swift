// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "PersonalTodo",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "PersonalTodo",
            path: "Sources"
        )
    ]
)
