// swift-tools-version:5.4
import PackageDescription

#if os(iOS) || os(tvOS) || os(watchOS) 
let executables:[Target] = []
#else 
let executables:[Target] = 
[
    .executableTarget(name: "Base64Tests", 
        dependencies: 
        [
            .target(name: "Testing"),
            .target(name: "Base64"),
        ],
        path: "Tests/Base64"),
    
    .executableTarget(name: "CRCTests", 
        dependencies: 
        [
            .target(name: "Testing"),
            .target(name: "CRC"),
        ],
        path: "Tests/CRC"),
    
    .executableTarget(name: "SHA2Tests", 
        dependencies: 
        [
            .target(name: "Testing"),
            .target(name: "SHA2"),
        ],
        path: "Tests/SHA2"),
]
#endif 

let package:Package = .init(
    name: "swift-hash",
    products:
    [
        .library(name: "Base16",  targets: ["Base16"]),
        .library(name: "Base64",  targets: ["Base64"]),
        .library(name: "SHA2", targets: ["SHA2"]),
        .library(name: "CRC", targets: ["CRC"]),

        .library(name: "Testing", targets: ["Testing"]),
    ],
    dependencies: 
    [
    ],
    targets: executables +
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

        .target(name: "SHA2", 
            dependencies: 
            [
                .target(name: "Base16"),
            ]),
        
        .target(name: "CRC", 
            dependencies: 
            [
                .target(name: "Base16"),
            ]),
        
        .target(name: "Testing"),
    ]
)
