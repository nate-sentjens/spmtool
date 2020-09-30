// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "spmtool",
    products: [
        .executable(name: "spmtool", targets: ["spmtool"])
    ],
    dependencies: [
        .package(url: "git@github.com:apple/swift-argument-parser.git", from: "0.3.1")
    ],
    targets: [
        .target(
            name: "spmtool",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ])
    ]
)
