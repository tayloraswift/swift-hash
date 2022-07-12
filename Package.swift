// swift-tools-version:5.4
import PackageDescription

let package:Package = .init(
    name: "swift-hash",
    products: 
    [
        .library(name: "Base16",  targets: ["Base16"]),
        .library(name: "SHA2",  targets: ["SHA2"]),
        .library(name: "CRC",   targets: ["CRC"]),
        
        .executable(name: "sha2-tests", targets: ["SHA2Tests"]),
    ],
    dependencies: 
    [
    ],
    targets: 
    [
        .target(name: "Base16"),
        .target(name: "SHA2", 
            dependencies: 
            [
                .target(name: "Base16"),
            ]),
        .target(name: "CRC", 
            dependencies: 
            [
            ]),
        
        .executableTarget(name: "SHA2Tests", 
            dependencies: 
            [
                .target(name: "SHA2"),
            ],
            path: "Tests/SHA2"),
    ]
)
