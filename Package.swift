// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HttpNetworking",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "HttpNetworking",
            targets: ["HttpNetworking"]
        ),
    ],
    targets: [
        .target(
            name: "HttpNetworking",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "HttpNetworkingTests",
            dependencies: ["HttpNetworking"]
        )
    ]
)
