# Filozoff/action-swift-propose-next-version

A GitHub Action that automatically suggests the next semantic version for your Swift package.

## Overview

This action analyzes your Swift package's public API changes between the current state and the last git tag to propose an appropriate semantic version bump (MAJOR, MINOR, or PATCH) according to [SemVer](https://semver.org) specifications.

This action leverages `xcodebuild`, enabling it to build Swift packages that import Apple's frameworks, such as `SwiftUI`. This ensures compatibility with a wide range of Swift packages that depend on these frameworks.

## Prerequisites

- **macOS runner**: The action must run on macOS (other platforms are not currently supported)
- **Git tags**: Must follow strict SemVer format (`MAJOR.MINOR.PATCH`, e.g., `1.1.2`)
- **Swift Package**: Repository must contain a single Swift package (supports package with multiple products).

## Usage

### Inputs

- `derived-data-path`: Derived data path (optional). Default: `./.build`.
- `device`: Specify the device for which the public interface is created. Use a value supported by the `-destination` argument from `xcodebuild archive`. Example: `platform=iOS Simulator,name=iPhone 16,OS=18.0`.
- `scheme`: The scheme name of the Swift package to analyze. Append `-Package` to analyze the entire package with multiple products.

### Outputs

The action provides the following outputs:

- `proposed-next-version`: Proposed next version number

### Basic Setup

```yaml
jobs:
  propose-version:
    runs-on: macos-latest
    outputs: # Use `outputs` variables for your next pipeline jobs
      proposed-version: ${{ steps.next-version-proposition.outputs.proposed-next-version }}
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0 # Fetches all history for all tags

      - name: Get next version proposition
        id: next-version-proposition
        uses: Filozoff/action-swift-propose-next-version@v1
        with:
          derived-data-path: "derived-data"
          device: "platform=iOS Simulator,name=iPhone 16,OS=18.0"
          scheme: "YourSwiftPackageScheme"
```

### Optimized Setup (for large repositories)

For large repositories, it is recommended to adjust the `fetch-depth` value in the checkout step based on your repository's tagging frequency. For example, you might set `fetch-depth` to 30. This ensures that the action has enough history to accurately propose the next version.

## Limitations

- Only works with macOS runners
- Requires valid SemVer git tags without prefixes/suffixes
- Analyzes a single Swift package per repository
- Does not support custom version prefixes (e.g., 'v1.0.0')

## License

[MIT License](LICENSE)
