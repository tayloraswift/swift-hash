// swift-tools-version:5.3
import PackageDescription

let package:Package = .init(
    name: "swift-hash",
    products: 
    [
        .library(name: "CRC",   targets: ["CRC"]),
        .library(name: "SHA2",  targets: ["SHA2"]),
        
        .executable(name: "sha2-tests", targets: ["SHA2Tests"]),
    ],
    dependencies: 
    [
    ],
    targets: 
    [
        .target(name: "CRC", 
            dependencies: 
            [
            ],
            path: "sources/crc", 
            exclude: 
            [
            ]),
        .target(name: "SHA2", 
            dependencies: 
            [
            ],
            path: "sources/sha2", 
            exclude: 
            [
            ]),
        
        .target(name: "SHA2Tests", 
            dependencies: 
            [
                .target(name: "SHA2"),
            ],
            path: "tests/sha2", 
            exclude: 
            [
            ]),
    ]
)
