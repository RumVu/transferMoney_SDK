# Features

Understand the package capabilities before choosing a version or integrating it into an app.

## Supported currencies

| Currency | Code | Symbol | Notes |
| --- | --- | --- | --- |
| Vietnamese Dong | `VND` | `đ` | Supported in direct and multi-step conversions |
| US Dollar | `USD` | `$` | Supported in all conversion paths |
| Australian Dollar | `AUD` | `A$` | Supported in direct and multi-step conversions |

## Supported conversion paths

| From | To | Path |
| --- | --- | --- |
| `VND` | `USD` | Direct |
| `USD` | `VND` | Direct |
| `USD` | `AUD` | Direct |
| `AUD` | `USD` | Direct |
| `VND` | `AUD` | Automatic via USD |
| `AUD` | `VND` | Automatic via USD |

## Rate customization

Use the configured default rate:

```swift
let result = try converter.convert(
    amount: 1_000_000,
    from: .VND,
    to: .USD,
    choose: .standard
)
```

Use a custom one-off rate:

```swift
let result = try converter.convert(
    amount: 1_000_000,
    from: .VND,
    to: .USD,
    choose: .customRate(26_000)
)
```

Update the runtime rate for future conversions:

```swift
try converter.updateExchangeRates(25_800)
```

## Precision and formatting

Create a custom configuration when you need fewer decimals for UI-facing values:

```swift
let config = ConversionConfigs(decimalPrecision: 2)
let converter = TransferMoney_core(config: config)
```

Each ``ConversionResults`` instance includes:

- `sourceAmount` and `targetAmount`
- `sourceCurrency` and `targetCurrency`
- `exchangeRate`
- `sdkVersion`
- `timeStamp`
- `FormattedSourceAmount`
- `FormattedTargetAmount`

## Reliability

- Local computation only.
- No network dependency.
- Typed errors through ``CurrenciesError``.
- Covered by automated tests in the package test target.
