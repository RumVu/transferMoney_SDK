# Releases & Version Selection

This file is the repository companion to the DocC page `Version Selection`. Use it when you need a plain Markdown guide in GitHub as well as inside hosted documentation.

## Recommended choices

| Version | Status | Best for |
| --- | --- | --- |
| `0.0.9` | Recommended stable | New integrations that want the current DocC structure, SPI metadata, and maintained release guidance |
| `0.0.8` | Stable previous | Existing production apps that already validated the prior release |
| `0.0.4` | Legacy stable | Older apps that specifically pinned around the six-path conversion rollout |
| `0.0.1` to `0.0.3` | Legacy | Reproducing or debugging early integrations only |

## Package.swift examples

Follow the current stable line:

```swift
.package(url: "https://github.com/RumVu/transferMoney_SDK.git", from: "0.0.9")
```

Pin a tested release:

```swift
.package(url: "https://github.com/RumVu/transferMoney_SDK.git", exact: "0.0.8")
```

Stay within the `0.0.x` family without automatically crossing into a future minor line:

```swift
.package(
    url: "https://github.com/RumVu/transferMoney_SDK.git",
    .upToNextMinor(from: "0.0.8")
)
```

## Migration notes

| Upgrade path | Impact |
| --- | --- |
| `0.0.8` → `0.0.9` | Documentation and release-management refresh only. Re-test your integration, but no package API change is expected. |
| `0.0.4` → `0.0.8` | Backward-compatible for the main conversion APIs. Review formatting-related UI snapshots if you expose formatted result strings. |
| `0.0.2` → `0.0.3` | Breaking change because `convert` switched from `standardRate: Bool` to `choose: ConversionOption`. |

## Developer guidance

- New app: start with `from: "0.0.9"`.
- Audited production app: use `exact:` and pin the release your team validated.
- Team sharing docs across versions: rely on Git tags so Swift Package Index can expose versioned documentation.

## Links

- Latest release: https://github.com/RumVu/transferMoney_SDK/releases/latest
- Tags: https://github.com/RumVu/transferMoney_SDK/tags
- Swift Package Index: https://swiftpackageindex.com/RumVu/transferMoney_SDK
