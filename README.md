# transferMoney SDK

A lightweight Swift package for converting between VND, USD, and AUD currencies.

## Features

- **Multi-currency support**: VND ↔ USD, USD ↔ AUD, VND ↔ AUD
- **Flexible exchange rates**: Use default rates or provide custom rates
- **Precise calculations**: Configurable decimal precision
- **Well-documented**: Complete DocC documentation with examples
- **Fully tested**: 17 comprehensive test cases
- **XCFramework ready**: Binary distribution with hidden implementation

## Supported Currency Pairs

| From | To | Notes |
|------|----|----|
| VND | USD | Direct conversion |
| USD | VND | Direct conversion |
| USD | AUD | Direct conversion |
| AUD | USD | Direct conversion |
| VND | AUD | Via USD intermediary |
| AUD | VND | Via USD intermediary |

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
.package(url: "https://github.com/RumVu/transferMoney_SDK.git", from: "0.0.4")
```

Or in Xcode: File → Add Packages → Enter repository URL

## Quick Start

### Basic Usage

```swift
import transferMoney_SDK

let converter = TransferMoney_core()

// VND to USD
let result = try converter.convert(
    amount: 1_000_000,
    from: .VND,
    to: .USD,
    choose: .standard
)
print(result.targetAmount)  // 39.29...
```

### Shorthand Methods

```swift
let usd = try converter.vndToUsd(1_000_000)  // ≈ 39.29
let vnd = try converter.usdToVnd(10)         // ≈ 254,500
```

### Custom Exchange Rates

```swift
let result = try converter.convert(
    amount: 1_000_000,
    from: .VND,
    to: .USD,
    choose: .customRate(25_800)
)
```

### Multi-step Conversions

```swift
// AUD to VND (automatically via USD)
let result = try converter.convert(
    amount: 50,
    from: .AUD,
    to: .VND,
    choose: .standard
)
```

## Default Exchange Rates

- **VND/USD**: 1 USD = 25,450 VND
- **AUD/USD**: 1 AUD = 0.63 USD

### Update Exchange Rates at Runtime

```swift
try converter.updateExchangeRates(25_800)
```

## Result Structure

Each conversion returns a `ConversionResults` object:

```swift
let result = try converter.convert(...)

result.sourceAmount      // Original amount
result.sourceCurrency    // Source currency (.VND, .USD, .AUD)
result.targetAmount      // Converted amount
result.targetCurrency    // Target currency
result.exchangeRate      // Exchange rate used
result.sdkVersion        // SDK version (e.g., "0.0.4")
result.timeStamp         // Conversion timestamp
```

## Error Handling

```swift
do {
    let result = try converter.convert(...)
} catch CurrenciesError.invalidAmount(let msg) {
    print("Invalid amount: \(msg)")
} catch CurrenciesError.invalidExchangeRates(let rate) {
    print("Invalid rate: \(rate)")
} catch CurrenciesError.unsupportedConversion(let from, let to) {
    print("Conversion not supported: \(from) → \(to)")
}
```

## Documentation

Full API documentation is available via DocC:

```bash
swift package --allow-writing-to-directory ./docs \
    generate-documentation \
    --target transferMoney_SDK \
    --output-path ./docs \
    --transform-for-static-hosting \
    --hosting-base-path transferMoney_SDK
```

View online: [GitHub Pages](https://rumvu.github.io/transferMoney_SDK/)

## Requirements

- Swift 6.0+
- iOS 15.0+ or macOS 12.0+

## License

MIT

## Author

Vũ Ngọc Quang Minh
