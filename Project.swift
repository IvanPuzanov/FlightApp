import ProjectDescription

let project = Project(
    name: "flight-demo",
    packages: [
        .remote(
            url: "https://github.com/SnapKit/SnapKit.git",
            requirement: .upToNextMajor(from: "5.7.1")
        ),
    ],
    targets: [
        .target(
            name: "flight-demo",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.ivanpuzanov.flight-demo",
            deploymentTargets: .iOS("16.6"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen",
                    "UIApplicationSupportsIndirectInputEvents": true,
                    "UISupportedInterfaceOrientations": [
                        "UIInterfaceOrientationPortrait"
                    ]
                ]
            ),
            buildableFolders: [
                .folder(
                    "flight-demo", exceptions: [.exception(excluded: ["Info.plist"])]
                )
            ],
            dependencies: [
                .package(product: "SnapKit", type: .runtimeEmbedded),
            ]
        )
    ]
)
