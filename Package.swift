// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "JSONAPI-ResourceStorage",
    products: [
        .library(
            name: "JSONAPIResourceStore",
            targets: ["JSONAPIResourceStore"]
        ),
        .library(
            name: "JSONAPIResourceCache",
            targets: ["JSONAPIResourceCache"]
        )
    ],
    dependencies: [
       .package(url: "https://github.com/mattpolzin/JSONAPI", from: "4.0.0-alpha.3.2"),
    ],
    targets: [
        .target(
            name: "JSONAPIResourceStore",
            dependencies: ["JSONAPI"]),
        .target(
            name: "JSONAPIResourceCache",
            dependencies: ["JSONAPI"]),
        .testTarget(
            name: "JSONAPIResourceStoreTests",
            dependencies: ["JSONAPIResourceStore", "JSONAPI", .product(name: "JSONAPITesting", package: "JSONAPI")]),
        .testTarget(
            name: "JSONAPIResourceCacheTests",
            dependencies: ["JSONAPIResourceCache", "JSONAPI", .product(name: "JSONAPITesting", package: "JSONAPI")])
    ]
)
