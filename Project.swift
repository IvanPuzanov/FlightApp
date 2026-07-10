import ProjectDescription

let appTarget = "FlightDemoApp"
let testsTarget = "Tests"

let project = Project(
    name: "FlightDemoApp",
    options: .options(
        automaticSchemesOptions: .disabled
    ),
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
                    "UILaunchScreen": [
                        "UIColorName": "systemBackgroundColor"
                    ],
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
    ],
    schemes: [
        .scheme(
            name: appTarget,
            shared: true,
            buildAction: .buildAction(targets: [.target(appTarget)]),
            runAction: .runAction(executable: .target(appTarget)),
            archiveAction: .archiveAction(configuration: .release),
            profileAction: .profileAction(configuration: .release, executable: .target(appTarget)),
            analyzeAction: .analyzeAction(configuration: .debug)
        ),
        .scheme(
            name: testsTarget,
            shared: true,
            buildAction: .buildAction(targets: [.target(appTarget), .target(testsTarget)]),
            testAction: .testPlans(
                [
                    .relativeToManifest("TestPlans/UnitTests.xctestplan")
                ],
                configuration: .debug
            ),
            analyzeAction: .analyzeAction(configuration: .debug)
        )
    ]
)
