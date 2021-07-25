// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GEmojiPicker",
    platforms: [
        .macOS(.v11), .iOS(.v14)
    ],
    products: [
        .library(
            name: "GEmojiPicker",
            targets: ["GEmojiPicker"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "GEmojiPicker",
            dependencies: []),
        .testTarget(
            name: "GEmojiPickerTests",
            dependencies: ["GEmojiPicker"]),
    ]
)
