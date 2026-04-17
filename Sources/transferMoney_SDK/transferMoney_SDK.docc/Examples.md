# Examples

Use these examples as copy-paste starting points for app integrations.

## Basic conversion

```swift
import transferMoney_SDK

let converter = TransferMoney_core()
let usd = try converter.vndToUsd(2_000_000)
print(usd)
```

## Full result object

```swift
let result = try converter.convert(
    amount: 100,
    from: .USD,
    to: .AUD,
    choose: .standard
)

print(result.sourceCurrency.rawValue)
print(result.targetCurrency.rawValue)
print(result.exchangeRate)
print(result.sdkVersion)
```

## Custom precision

```swift
let converter = TransferMoney_core(
    config: ConversionConfigs(decimalPrecision: 2)
)

let result = try converter.convert(
    amount: 1_000_000,
    from: .VND,
    to: .USD,
    choose: .standard
)
```

## Custom rate for a single conversion

```swift
let result = try converter.convert(
    amount: 1_000_000,
    from: .VND,
    to: .USD,
    choose: .customRate(26_000)
)
```

## Error handling

```swift
do {
    _ = try converter.convert(
        amount: -100,
        from: .VND,
        to: .USD,
        choose: .standard
    )
} catch CurrenciesError.invalidAmount(let message) {
    print(message)
}
```
