// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "JSONAPI-ResourceStore",
    products: [
        .library(
            name: "JSONAPIResourceStore",
            targets: ["JSONAPIResourceStore"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/mattpolzin/JSONAPI", from: "4.0.0-alpha.3"),
    ],
    targets: [
        .target(
            name: "JSONAPIResourceStore",
            dependencies: ["JSONAPI"]),
        .testTarget(
            name: "JSONAPIResourceStoreTests",
            dependencies: ["JSONAPIResourceStore", "JSONAPI", .product(name: "JSONAPITesting", package: "JSONAPI")]),
    ]
)
