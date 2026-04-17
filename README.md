# transferMoney SDK

A lightweight Swift package for converting between VND, USD, and AUD with versioned DocC documentation and Swift Package Index support.

## Why this package

- Direct `VND ↔ USD` and `USD ↔ AUD` conversions.
- Automatic `VND ↔ AUD` conversions through USD.
- Configurable exchange rates and decimal precision.
- Typed result objects and error handling.
- DocC-ready guides for onboarding, release notes, and version selection.

## Installation

For new projects, follow the current stable line:

```swift
.package(url: "https://github.com/RumVu/transferMoney_SDK.git", from: "0.0.9")
```

For production apps that must stay on a validated release:

```swift
.package(url: "https://github.com/RumVu/transferMoney_SDK.git", exact: "0.0.8")
```

## Quick Start

```swift
import transferMoney_SDK

let converter = TransferMoney_core()
let result = try converter.convert(
    amount: 1_000_000,
    from: .VND,
    to: .USD,
    choose: .standard
)

print(result.targetAmount)
print(result.FormattedTargetAmount)
```

## Common tasks

Use shorthand helpers:

```swift
let usd = try converter.vndToUsd(1_000_000)
let vnd = try converter.usdToVnd(10)
```

Use a custom one-off rate:

```swift
let result = try converter.convert(
    amount: 1_000_000,
    from: .VND,
    to: .USD,
    choose: .customRate(25_800)
)
```

Update the runtime rate:

```swift
try converter.updateExchangeRates(25_800)
```

## Documentation

Generate the static documentation site locally:

```bash
swift package --allow-writing-to-directory ./build-docs \
  generate-documentation \
  --target transferMoney_SDK \
  --output-path ./build-docs \
  --transform-for-static-hosting \
  --hosting-base-path transferMoney_SDK
```

The authored documentation lives in `Sources/transferMoney_SDK/transferMoney_SDK.docc`, and Swift Package Index can build versioned docs through the root `.spi.yml` manifest.

## Requirements

- Swift 6.0+
- iOS 15.0+
- macOS 12.0+

## License

MIT
