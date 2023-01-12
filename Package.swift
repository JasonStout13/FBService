// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FBService",
    platforms: [
        .iOS(.v15), .macOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FBService",
            targets: ["FBService"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "9.3.0"),
        .package(url: "https://github.com/marksands/BetterCodable.git", from: "0.4.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "FBService",
            dependencies: [
                .product(name: "FirebaseAuth", package: "FBService"),
                .product(name: "FirebaseFirestore", package: "FBService"),
                .product(name: "FirebaseFirestoreSwift", package: "FBService"),
                .product(name: "FirebaseStorage", package: "FBService"),
                .product(name: "FirebaseFunctions", package: "FBService"),
                "BetterCodable"
            ]),
        .testTarget(
            name: "FBServiceTests",
            dependencies: ["FBService"]),
    ]
)
