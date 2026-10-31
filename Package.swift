// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftDropdown",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "SwiftDropdown", targets: ["SwiftDropdown"])
    ],
    targets: [
        .target(name: "SwiftDropdown")
    ]
)
