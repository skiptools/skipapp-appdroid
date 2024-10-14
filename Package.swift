// swift-tools-version: 5.9
// This is a Skip (https://skip.tools) package,
// containing a Swift Package Manager project
// that will use the Skip build plugin to transpile the
// Swift Package, Sources, and Tests into an
// Android Gradle Project with Kotlin sources and JUnit tests.
import PackageDescription

let package = Package(
    name: "skipapp-appdroid",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14), .tvOS(.v16), .watchOS(.v9), .macCatalyst(.v16)],
    products: [
        .library(name: "AppDroidApp", type: .dynamic, targets: ["AppDroid"]),
        .library(name: "AppDroidModel", type: .dynamic, targets: ["AppDroidModel"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.1.10"),
        .package(url: "https://source.skip.tools/skip-ui.git", branch: "main"),
        .package(url: "https://source.skip.tools/skip-bridge.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0"),
    ],
    targets: [
        .target(name: "AppDroid", dependencies: [
            "AppDroidModel",
            .product(name: "SkipUI", package: "skip-ui", condition: .when(platforms: [.macOS, .iOS])),
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "AppDroidTests", dependencies: [
            "AppDroid",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .target(name: "AppDroidModel", dependencies: [
            .product(name: "SkipBridge", package: "skip-bridge"),
            .product(name: "Algorithms", package: "swift-algorithms"),
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "AppDroidModelTests", dependencies: [
            "AppDroidModel",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
