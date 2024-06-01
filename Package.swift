// swift-tools-version:5.8
import PackageDescription

let package:Package = .init(
    name: "swift-hash",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "Base16",                targets: ["Base16"]),
        .library(name: "Base64",                targets: ["Base64"]),
        .library(name: "CRC",                   targets: ["CRC"]),
        .library(name: "InlineBuffer",          targets: ["InlineBuffer"]),
        .library(name: "MD5",                   targets: ["MD5"]),
        .library(name: "MessageAuthentication", targets: ["MessageAuthentication"]),
        .library(name: "SHA1",                  targets: ["SHA1"]),
        .library(name: "SHA2",                  targets: ["SHA2"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tayloraswift/swift-grammar", .upToNextMinor(
            from: "0.4.0")),
    ],
    targets: [
        .target(name: "BaseDigits"),

        .target(name: "Base16",
            dependencies: [
                .target(name: "BaseDigits"),
            ]),

        .target(name: "Base64",
            dependencies: [
                .target(name: "BaseDigits"),
            ]),

        .target(name: "CRC",
            dependencies: [
                .target(name: "Base16"),
            ]),

        .target(name: "InlineBuffer"),

        .target(name: "MD5",
            dependencies: [
                .target(name: "InlineBuffer"),
            ]),

        .target(name: "MessageAuthentication"),

        .target(name: "SHA1",
            dependencies: [
                .target(name: "InlineBuffer"),
            ]),

        .target(name: "SHA2",
            dependencies: [
                .target(name: "Base16"),
                .target(name: "MessageAuthentication"),
            ]),

        .executableTarget(name: "Base64Tests",
            dependencies: [
                .product(name: "Testing_", package: "swift-grammar"),
                .target(name: "Base64"),
            ]),

        .executableTarget(name: "CRCTests",
            dependencies: [
                .product(name: "Testing_", package: "swift-grammar"),
                .target(name: "CRC"),
            ]),

        .executableTarget(name: "MD5Tests",
            dependencies: [
                .target(name: "MD5"),
                .product(name: "Testing_", package: "swift-grammar"),
            ]),

        .executableTarget(name: "SHA2Tests",
            dependencies: [
                .product(name: "Testing_", package: "swift-grammar"),
                .target(name: "SHA2"),
            ]),
    ]
)

for target:PackageDescription.Target in package.targets
{
    {
        var settings:[PackageDescription.SwiftSetting] = $0 ?? []

        settings.append(.enableUpcomingFeature("BareSlashRegexLiterals"))
        settings.append(.enableUpcomingFeature("ConciseMagicFile"))
        settings.append(.enableUpcomingFeature("DeprecateApplicationMain"))
        settings.append(.enableUpcomingFeature("ExistentialAny"))
        settings.append(.enableUpcomingFeature("GlobalConcurrency"))
        settings.append(.enableUpcomingFeature("IsolatedDefaultValues"))
        settings.append(.enableExperimentalFeature("StrictConcurrency"))

        settings.append(.define("DEBUG", .when(configuration: .debug)))

        $0 = settings
    } (&target.swiftSettings)
}
