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
            url: "https://github.com/est-perso-live/perso-livechat-ondevice-sdk-swift/releases/download/0.2.0/PersoLiveChatOnDeviceSDK.xcframework.zip",
            checksum: "31426d3ae81829cb8aa804646d2ec9cf1c2684352c25c0494059584e0d260c11"
        )
    ]
)
