// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "FlizpaySDK",
    defaultLocalization: "de",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "FlizpaySDK",
            targets: ["FlizpaySDK"]
        ),
        .library(
            name: "Lib",
            targets: ["Lib"]
        )
    ],
    dependencies: [
        // Add dependencies if needed
    ],
    targets: [
        .target(
            name: "FlizpaySDK",
            dependencies: [],
            path: "Sources/FlizpaySDK"
        ),
        .target(
            name: "Lib",
            dependencies: [],
            path: "Sources/Lib"
        ),
        .testTarget(
            name: "FlizpaySDKTests",
            dependencies: ["FlizpaySDK"],
            path: "Tests/FlizpaySDKTests"
        )
    ]
)
