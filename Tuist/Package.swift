// swift-tools-version: 6.3
import PackageDescription

let package = Package(
    name: "FlightAppDependencies",
    dependencies: [
        .package(
            url: "https://github.com/SnapKit/SnapKit.git",
            .upToNextMajor(from: "5.7.1")
        )
    ]
)
