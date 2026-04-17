# Welcome

Start here if you want the quickest path to a working integration and a clear overview of what this SDK gives your team.

## Why teams use transferMoney SDK

- Offline conversion logic with zero API dependencies.
- Support for VND, USD, and AUD in a single package.
- Configurable exchange rates and decimal precision.
- Typed Swift API with structured results and error handling.
- Hosted DocC documentation that can be published through DocC static hosting or Swift Package Index.

## Quick Start

Add the package:

```swift
.package(url: "https://github.com/RumVu/transferMoney_SDK.git", from: "0.0.9")
```

Import and convert:

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

## What to read next

- <doc:Features> for supported conversion paths and customization options.
- <doc:DeveloperTools> for build, test, release, and DocC deployment commands.
- <doc:VersionSelection> for choosing the right SDK version for a project instead of always taking the newest one.
