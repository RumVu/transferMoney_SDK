# Version Selection

Choose the version that matches your project stability needs. The best choice is not always the newest tag.

## Recommended versions

| Version | Status | Choose it when | Skip it when |
| --- | --- | --- | --- |
| `0.0.9` | Recommended stable | You want the current DocC structure, SPI-ready metadata, and the latest maintained docs set. | You are pinned to an older audited release. |
| `0.0.8` | Stable previous | Your project already shipped on `0.0.8` and only needs the earlier API surface. | You want the improved documentation publishing flow. |
| `0.0.4` | Legacy stable | You need the release that introduced the full six-path conversion matrix and cannot move yet. | You want the current documentation and release guidance. |
| `0.0.1` to `0.0.3` | Legacy | You are reproducing an old integration or debugging an early tag. | You are starting a new project. |

## Package.swift examples

Track the current stable line:

```swift
.package(url: "https://github.com/RumVu/transferMoney_SDK.git", from: "0.0.9")
```

Pin an exact production-tested release:

```swift
.package(url: "https://github.com/RumVu/transferMoney_SDK.git", exact: "0.0.8")
```

Stay inside the `0.0.x` line without crossing into a future minor version:

```swift
.package(
    url: "https://github.com/RumVu/transferMoney_SDK.git",
    .upToNextMinor(from: "0.0.8")
)
```

## Xcode guidance

When adding the package in Xcode:

1. Pick `Up to Next Major Version` for new projects that should follow the current stable line.
2. Pick `Exact Version` for regulated, audited, or tightly tested production apps.
3. Document the selected version in your app repository so teams know why that version was chosen.

## Migration notes

| Upgrade path | Compatibility |
| --- | --- |
| `0.0.8` → `0.0.9` | Compatible documentation and release-management refresh. No package API change expected. |
| `0.0.4` → `0.0.8` | Backward-compatible for the established conversion APIs. Re-test if you depend on exact formatting output. |
| `0.0.2` → `0.0.3` | Breaking change because `convert` moved from `standardRate: Bool` to `choose: ConversionOption`. |

## How documentation versions appear on SPI

Swift Package Index creates versioned documentation from your Git tags. That means developers will be able to switch documentation versions per release, while this page helps them decide which release is the right one for their project.
