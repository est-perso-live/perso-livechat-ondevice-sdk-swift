// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "perso-livechat-ondevice-sdk-swift",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "PersoLiveChatOnDeviceSDK",
            targets: [
                "PersoLiveChatOnDeviceSDK"
            ]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "PersoLiveChatOnDeviceSDK",
            url: "https://github.com/est-perso-live/perso-livechat-ondevice-sdk-swift/releases/download/0.1.0/PersoLiveChatOnDeviceSDK.xcframework.zip",
            checksum: "5843d2ca9faf8ae481de55444c044fc1dd46af57e130c1e786ede2ed155e2d82"
        )
    ]
)
