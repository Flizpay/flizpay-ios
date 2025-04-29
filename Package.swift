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
            targets: ["FlizpaySDK"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FlizpaySDK",
            cSettings: [
                .unsafeFlags(["-arch", "x86_64", "-arch", "arm64"])
            ]),
        .testTarget(
            name: "FlizpaySDKTests",
            dependencies: ["FlizpaySDK"]),
    ]
)
