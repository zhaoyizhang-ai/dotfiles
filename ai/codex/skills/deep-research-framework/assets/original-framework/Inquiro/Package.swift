// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Inquiro",
    platforms: [.macOS(.v15)],
    products: [
        .executable(name: "Inquiro", targets: ["Inquiro"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "Inquiro",
            dependencies: [],
            path: "Inquiro"
        ),
        .testTarget(
            name: "InquiroTests",
            dependencies: ["Inquiro"],
            path: "InquiroTests"
        )
    ]
)
