# API Reference

## Tài liệu chi tiết API transferMoney SDK

---

## TransferMoneySDK (Namespace)

**File:** `Sources/transferMoney_SDK/transferMoney_SDK.swift`

Static namespace chứa metadata của SDK.

### Properties

#### `version: String`
Phiên bản hiện tại của SDK.

```swift
let version = TransferMoneySDK.version  // "0.0.4"
```

#### `defaultVNDToUSDRate: Double`
Tỷ giá VND/USD mặc định.

```swift
let rate = TransferMoneySDK.defaultVNDToUSDRate  // 25450.0
```

#### `defaultAUDToUSDRate: Double`
Tỷ giá AUD/USD mặc định.

```swift
let rate = TransferMoneySDK.defaultAUDToUSDRate  // 0.63
```

---

## TransferMoney_core (Main Class)

**File:** `Sources/transferMoney_SDK/Core/TransferMoney_core.swift`

Class chính để thực hiện chuyển đổi tiền tệ.

### Initialization

#### `init()`
Tạo converter với cấu hình mặc định.

```swift
let converter = TransferMoney_core()
// Tỷ giá: VND/USD = 25450, AUD/USD = 0.63
// Decimal precision: 6
```

#### `init(config: ConversionConfigs)`
Tạo converter với cấu hình tuỳ chỉnh.

```swift
let config = ConversionConfigs(VNDtoUSDRate: 25_800, decimalPrecision: 2)
let converter = TransferMoney_core(config: config)
```

### Properties

#### `config: ConversionConfigs` (read-only)
Cấu hình hiện tại của converter.

```swift
print(converter.config.VNDtoUSDRate)     // 25450.0
print(converter.config.decimalPrecision) // 6
```

### Methods

#### `updateExchangeRates(_ rate: Double) throws`
Cập nhật tỷ giá VND/USD tại runtime.

**Parameters:**
- `rate: Double` - Tỷ giá mới (phải > 0)

**Throws:**
- `CurrenciesError.invalidExchangeRates` - Nếu rate <= 0

```swift
try converter.updateExchangeRates(25_800)
```

---

#### `convert(amount:from:to:choose:) throws -> ConversionResults`
Chuyển đổi tiền giữa hai loại tiền tệ.

**Parameters:**
- `amount: Double` - Số tiền (phải >= 0)
- `from: Currency` - Loại tiền nguồn
- `to: Currency` - Loại tiền đích
- `choose: ConversionOption` - Tuỳ chọn tỷ giá

**Returns:**
- `ConversionResults` - Kết quả conversion

**Throws:**
- `CurrenciesError.invalidAmount` - Nếu amount < 0
- `CurrenciesError.invalidExchangeRates` - Nếu rate không hợp lệ
- `CurrenciesError.unsupportedConversion` - Nếu cặp tiền không hỗ trợ

**Example:**
```swift
let result = try converter.convert(
    amount: 1_000_000,
    from: .VND,
    to: .USD,
    choose: .standard
)
print(result.targetAmount)  // 39.292...
```

**Supported Conversions:**
- VND → USD, USD → VND
- USD → AUD, AUD → USD
- VND → AUD, AUD → VND
- Same → Same (passthrough)

---

#### `vndToUsd(_ vnd: Double) throws -> Double`
Shorthand: Convert VND to USD.

**Parameters:**
- `vnd: Double` - Số tiền VND (phải >= 0)

**Returns:**
- `Double` - Số tiền USD

**Throws:**
- `CurrenciesError.invalidAmount`

```swift
let usd = try converter.vndToUsd(1_000_000)  // 39.292...
```

---

#### `usdToVnd(_ usd: Double) throws -> Double`
Shorthand: Convert USD to VND.

**Parameters:**
- `usd: Double` - Số tiền USD (phải >= 0)

**Returns:**
- `Double` - Số tiền VND

**Throws:**
- `CurrenciesError.invalidAmount`

```swift
let vnd = try converter.usdToVnd(10)  // 254500.0
```

---

## ConversionConfigs (Configuration)

**File:** `Sources/transferMoney_SDK/Model/ConversionConfigs.swift`

Cấu hình cho converter.

### Properties

#### `VNDtoUSDRate: Double`
Tỷ giá VND/USD (số VND tương đương 1 USD).

```swift
config.VNDtoUSDRate = 25_800  // Mutable
```

#### `AUDtoUSDRate: Double`
Tỷ giá AUD/USD (số AUD tương đương 1 USD).

```swift
config.AUDtoUSDRate = 0.65
```

#### `decimalPrecision: Int`
Số chữ số thập phân dùng làm tròn.

```swift
config.decimalPrecision = 2  // 39.29 (2 chữ số)
```

### Initialization

#### `init(VNDtoUSDRate:AUDtoUSDRate:decimalPrecision:)`

```swift
let config = ConversionConfigs(
    VNDtoUSDRate: 25_800,
    AUDtoUSDRate: 0.65,
    decimalPrecision: 2
)
```

---

## Currency (Enum)

**File:** `Sources/transferMoney_SDK/Model/Currency.swift`

Enum các loại tiền tệ được hỗ trợ.

### Cases

```swift
case VND   // Đồng Việt Nam
case USD   // Đô la Mỹ
case AUD   // Đô la Úc
```

### Properties

#### `displayName: String`
Tên đầy đủ của tiền tệ.

```swift
Currency.VND.displayName  // "VietNam Dong"
Currency.USD.displayName  // "Dollar"
Currency.AUD.displayName  // "Australian Dollar"
```

#### `symbol: String`
Ký hiệu của tiền tệ.

```swift
Currency.VND.symbol  // "đ"
Currency.USD.symbol  // "$"
Currency.AUD.symbol  // "A$"
```

#### `rawValue: String`
Code tiền tệ.

```swift
Currency.VND.rawValue  // "VND"
Currency.USD.rawValue  // "USD"
Currency.AUD.rawValue  // "AUD"
```

#### `allCases: [Currency]`
Danh sách tất cả các tiền tệ.

```swift
for currency in Currency.allCases {
    print(currency.rawValue)  // VND, USD, AUD
}
```

---

## ConversionOption (Enum)

**File:** `Sources/transferMoney_SDK/Model/ConversionOption.swift`

Tuỳ chọn tỷ giá cho conversion.

### Cases

#### `standard`
Dùng tỷ giá mặc định được cấu hình.

```swift
choose: .standard
```

#### `customRate(_ rate: Double)`
Dùng tỷ giá tạm thời cho lần này.

```swift
choose: .customRate(26_000)  // 1 USD = 26,000 VND
```

---

## ConversionResults (Result)

**File:** `Sources/transferMoney_SDK/Model/ConversionResults.swift`

Kết quả của conversion.

### Properties

#### `sourceAmount: Double`
Số tiền gốc.

```swift
result.sourceAmount  // 1000000.0
```

#### `sourceCurrency: Currency`
Loại tiền nguồn.

```swift
result.sourceCurrency  // .VND
```

#### `targetAmount: Double`
Số tiền đã chuyển đổi.

```swift
result.targetAmount  // 39.292...
```

#### `targetCurrency: Currency`
Loại tiền đích.

```swift
result.targetCurrency  // .USD
```

#### `exchangeRate: Double`
Tỷ giá được sử dụng.

```swift
result.exchangeRate  // 25450.0
```

#### `sdkVersion: String`
Phiên bản SDK.

```swift
result.sdkVersion  // "0.0.4"
```

#### `timeStamp: Date`
Thời gian conversion.

```swift
result.timeStamp  // 2026-04-17 10:30:45
```

### Computed Properties

#### `FormattedSourceAmount: String`
Số tiền gốc được định dạng.

```swift
result.FormattedSourceAmount  // "₫ 1,000,000.00"
```

#### `FormattedTargetAmount: String`
Số tiền đích được định dạng.

```swift
result.FormattedTargetAmount  // "$ 39.2927"
```

---

## CurrenciesError (Error)

**File:** `Sources/transferMoney_SDK/Model/CurrenciesError.swift`

Các lỗi có thể xảy ra.

### Cases

#### `invalidAmount(String)`
Số tiền không hợp lệ (< 0).

```swift
catch CurrenciesError.invalidAmount(let msg) {
    print(msg)  // "Amount must be >= 0, got -100"
}
```

#### `invalidExchangeRates(Double)`
Tỷ giá không hợp lệ (<= 0).

```swift
catch CurrenciesError.invalidExchangeRates(let rate) {
    print("Invalid rate: \(rate)")
}
```

#### `unsupportedConversion(from: Currency, to: Currency)`
Cặp tiền không được hỗ trợ.

```swift
catch CurrenciesError.unsupportedConversion(let from, let to) {
    print("\(from) → \(to) not supported")
}
```

---

## Complete Example

```swift
import transferMoney_SDK

// 1. Khởi tạo
let converter = TransferMoney_core()

// 2. Convert VND → USD
do {
    let result = try converter.convert(
        amount: 1_000_000,
        from: .VND,
        to: .USD,
        choose: .standard
    )
    
    print("Source: \(result.FormattedSourceAmount)")  // ₫ 1,000,000.00
    print("Target: \(result.FormattedTargetAmount)")  // $ 39.2927
    print("Rate: \(result.exchangeRate)")             // 25450.0
    
} catch CurrenciesError.invalidAmount(let msg) {
    print("Error: \(msg)")
}

// 3. Update rate
try converter.updateExchangeRates(25_800)

// 4. Shorthand
let usd = try converter.vndToUsd(2_000_000)  // 77.58...
let vnd = try converter.usdToVnd(50)         // 1,272,500.0
```

---

**Tiếp theo:** [Examples](EXAMPLES.md)
