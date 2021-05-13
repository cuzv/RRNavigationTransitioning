// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RRNavigationTransitioning",
    platforms: [
        .iOS(.v9),
    ],
    products: [
        .library(name: "RRNavigationTransitioning", targets: ["RRNavigationTransitioning"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "RRNavigationTransitioning",
            path: "Sources",
            exclude: [
                "Info.plist",
            ],
            publicHeadersPath: "Public",
            cSettings: [
                .headerSearchPath("Internal"),
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
