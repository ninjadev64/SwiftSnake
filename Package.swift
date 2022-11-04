// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "SwiftSnake",
    dependencies: [
        .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.1"),
    ],
    targets: [
        .executableTarget(
            name: "SwiftSnake",
            dependencies: ["Rainbow"]
		)
    ]
)