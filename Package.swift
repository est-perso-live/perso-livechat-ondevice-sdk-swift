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
            url: "https://github.com/est-perso-live/perso-livechat-ondevice-sdk-swift/releases/download/0.3.0/PersoLiveChatOnDeviceSDK.xcframework.zip",
            checksum: "098926691664101c2ce0540dfd10c0a45c0edb75d3a53127496afb462bd7be79"
        )
    ]
)
