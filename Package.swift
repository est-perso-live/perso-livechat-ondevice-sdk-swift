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
            url: "https://github.com/est-perso-live/perso-livechat-ondevice-sdk-swift/releases/download/0.4.0/PersoLiveChatOnDeviceSDK.xcframework.zip",
            checksum: "6b74c1bc181e16ea6008416e4e9e5b8b9c3fbbf453d14391fa80693dabd81d42"
        )
    ]
)
