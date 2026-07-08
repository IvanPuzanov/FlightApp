import ProjectDescription

let project = Project(
    name: "FlightDemoApp",
    packages: [
        .remote(
            url: "https://github.com/SnapKit/SnapKit.git",
            requirement: .upToNextMajor(from: "5.7.1")
        ),
    ],
    targets: [
        .target(
            name: "FlightDemoApp",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.ivanpuzanov.flight-demo-app",
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
                    "Development", exceptions: [.exception(excluded: ["Info.plist"])]
                )
            ],
            dependencies: [
                .package(product: "SnapKit", type: .runtime),
            ],
            settings: .settings(
                base: ["DEVELOPMENT_TEAM": "T9GV6HD4BD"]
            )
        ),
        .target(
            name: "Tests",
            destinations: [.iPhone],
            product: .unitTests,
            bundleId: "com.ivanpuzanov.flight-demo-app-tests",
            deploymentTargets: .iOS("16.6"),
            infoPlist: .default,
            sources: ["Tests/**/*.swift"],
            dependencies: [
                .target(name: "FlightDemoApp"),
            ],
            settings: .settings(
                base: ["DEVELOPMENT_TEAM": "T9GV6HD4BD"]
            )
        )
    ]
)
