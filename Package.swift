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
        .package(url: "https://source.skip.tools/skip-model.git", from: "1.0.0"),
        .package(url: "https://source.skip.tools/skip-ui.git", from: "1.0.0"),
        .package(url: "https://source.skip.tools/skip-fuse.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.2.0"),
    ],
    targets: [
        // mode=kotlin bridging=false
        .target(name: "AppDroid", dependencies: [
            "AppDroidModel",
            .product(name: "SkipUI", package: "skip-ui"),
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "AppDroidTests", dependencies: [
            "AppDroid",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
        // mode=swift bridging=true
        .target(name: "AppDroidModel", dependencies: [
            .product(name: "SkipModel", package: "skip-model"),
            .product(name: "SkipFuse", package: "skip-fuse"),
            .product(name: "Algorithms", package: "swift-algorithms"),
        ], resources: [.process("Resources"), /*.embedInCode("CodeResources/sample_resource.json")*/], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "AppDroidModelTests", dependencies: [
            "AppDroidModel",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
