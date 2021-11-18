// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MemoireUI",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MemoireUI",
            targets: ["MemoireUI"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "MemoireIdentifiers", path: "/Users/lihaokun/Desktop/Graduation Project/MemoireIdentifiers/"),
        .package(name: "MemoireFoundation", path: "/Users/lihaokun/Desktop/Graduation Project/MemoireFoundation/")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MemoireUI",
            dependencies: [],
            resources: [.process("MFont/Resources"),
                        .process("Resources/MUI.xcassets")]),
        .testTarget(
            name: "MemoireUITests",
            dependencies: ["MemoireUI"]),
    ]
)
