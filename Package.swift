// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "transferMoney_SDK_v001",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "transferMoney_SDK_v001",
            targets: ["transferMoney_SDK_v001"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "transferMoney_SDK_v001"
        ),
        .testTarget(
            name: "transferMoney_SDK_v001Tests",
            dependencies: ["transferMoney_SDK_v001"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
