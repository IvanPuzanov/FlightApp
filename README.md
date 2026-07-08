# Flight Demo

iOS demo app built with [Tuist](https://tuist.dev). The Xcode project is generated from `Project.swift` and is not committed to the repository.

## Requirements

- Xcode 16+
- [Tuist](https://docs.tuist.dev/guides/quick-start/install-tuist) 4.22.0 (see [`.tuist-version`](.tuist-version))

## Getting Started

```bash
git clone git@github.com:IvanPuzanov/flightApp.git
cd flightApp
tuist generate
open FlightDemoApp.xcworkspace
```

Build and run the `FlightDemoApp` scheme in Xcode.

## Tests

```bash
tuist generate
xcodebuild test \
  -workspace FlightDemoApp.xcworkspace \
  -scheme FlightDemoApp \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

Or press `Cmd+U` in Xcode.

## Notes

- After pulling changes that touch `Project.swift` or [`.package.resolved`](.package.resolved), run `tuist generate` again.
- Update `DEVELOPMENT_TEAM` in [`Project.swift`](Project.swift) if you need to run on a physical device with your own Apple Developer account.
