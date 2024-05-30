// swift-tools-version:5.7
import PackageDescription

let package:Package = .init(
    name: "swift-hash",
    products:
    [
        .library(name: "Base16",                targets: ["Base16"]),
        .library(name: "Base64",                targets: ["Base64"]),
        .library(name: "CRC",                   targets: ["CRC"]),
        .library(name: "MessageAuthentication", targets: ["MessageAuthentication"]),
        .library(name: "SHA2",                  targets: ["SHA2"]),
    ],
    dependencies:
    [
        .package(url: "https://github.com/tayloraswift/swift-grammar", .upToNextMinor(
            from: "0.4.0")),
    ],
    targets:
    [
        .target(name: "BaseDigits"),

        .target(name: "Base16",
            dependencies:
            [
                .target(name: "BaseDigits"),
            ]),

        .target(name: "Base64",
            dependencies:
            [
                .target(name: "BaseDigits"),
            ]),

        .target(name: "CRC",
            dependencies:
            [
                .target(name: "Base16"),
            ]),

        .target(name: "MessageAuthentication"),

        .target(name: "SHA2",
            dependencies:
            [
                .target(name: "Base16"),
                .target(name: "MessageAuthentication"),
            ]),

        .executableTarget(name: "Base64Tests",
            dependencies:
            [
                .product(name: "Testing_", package: "swift-grammar"),
                .target(name: "Base64"),
            ]),

        .executableTarget(name: "CRCTests",
            dependencies:
            [
                .product(name: "Testing_", package: "swift-grammar"),
                .target(name: "CRC"),
            ]),

        .executableTarget(name: "SHA2Tests",
            dependencies:
            [
                .product(name: "Testing_", package: "swift-grammar"),
                .target(name: "SHA2"),
            ]),
    ]
)
