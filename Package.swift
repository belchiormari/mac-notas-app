// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "NotasRapidas",
    platforms: [
        .macOS(.v12)
    ],
    targets: [
        .executableTarget(
            name: "NotasRapidas",
            path: "Sources/NotasRapidas"
        )
    ]
)
