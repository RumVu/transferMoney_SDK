# Features

## Các tính năng chính của transferMoney SDK

### 1. 🌍 Hỗ trợ 3 loại tiền tệ

Hỗ trợ chuyển đổi giữa 3 tiền tệ phổ biến:

| Tiền tệ | Code | Ký hiệu | Mô tả |
|--------|------|--------|-------|
| Đồng Việt Nam | VND | đ | Tiền của Việt Nam |
| Đô la Mỹ | USD | $ | Tiền của Mỹ |
| Đô la Úc | AUD | A$ | Tiền của Úc |

### 2. 💱 6 đường chuyển đổi được hỗ trợ

```
VND ↔ USD    (chuyển đổi trực tiếp)
USD ↔ AUD    (chuyển đổi trực tiếp)
VND ↔ AUD    (qua USD trung gian - tự động)
```

**Ví dụ:**
```swift
// VND → USD
let result1 = try converter.convert(amount: 1_000_000, from: .VND, to: .USD, choose: .standard)

// USD → AUD
let result2 = try converter.convert(amount: 100, from: .USD, to: .AUD, choose: .standard)

// VND → AUD (tự động qua USD)
let result3 = try converter.convert(amount: 2_000_000, from: .VND, to: .AUD, choose: .standard)
```

---

### 3. ⚙️ Tỷ giá tuỳ chỉnh

#### Tỷ giá mặc định
- **VND/USD**: 1 USD = 25,450 VND
- **AUD/USD**: 1 AUD = 0.63 USD

#### Update tỷ giá lúc runtime
```swift
try converter.updateExchangeRates(25_800)  // Update VND/USD rate
```

#### Dùng tỷ giá tạm thời cho 1 lần convert
```swift
let result = try converter.convert(
    amount: 1_000_000,
    from: .VND,
    to: .USD,
    choose: .customRate(26_000)  // Chỉ cho lần này
)
```

---

### 4. 🎯 Độ chính xác tuỳ chọn

Cấu hình số chữ số thập phân:

```swift
// Mặc định: 6 chữ số thập phân
let config = ConversionConfigs()

// Tuỳ chỉnh: 2 chữ số
let config2 = ConversionConfigs(decimalPrecision: 2)

let converter = TransferMoney_core(config: config2)
let result = try converter.convert(amount: 1_000_000, from: .VND, to: .USD, choose: .standard)
print(result.targetAmount)  // 39.29 (2 chữ số)
```

---

### 5. 📊 Kết quả chi tiết

Mỗi lần convert trả về `ConversionResults` với đầy đủ thông tin:

```swift
let result = try converter.convert(amount: 1_000_000, from: .VND, to: .USD, choose: .standard)

result.sourceAmount       // 1000000.0 (số tiền gốc)
result.sourceCurrency     // .VND
result.targetAmount       // 39.292... (số tiền đã convert)
result.targetCurrency     // .USD
result.exchangeRate       // 25450.0 (tỷ giá dùng)
result.sdkVersion         // "0.0.4" (phiên bản SDK)
result.timeStamp          // 2026-04-17 10:30:45 (thời gian convert)

// Định dạng sẵn
result.FormattedSourceAmount    // "₫ 1,000,000.00"
result.FormattedTargetAmount    // "$ 39.2927"
```

---

### 6. ⚡ Phương thức Shorthand

Để nhanh gọn khi chỉ cần con số:

```swift
// Thay vì:
let result = try converter.convert(amount: 1_000_000, from: .VND, to: .USD, choose: .standard)
let usd = result.targetAmount

// Dùng shorthand:
let usd = try converter.vndToUsd(1_000_000)  // ≈ 39.29
let vnd = try converter.usdToVnd(10)         // ≈ 254,500
```

---

### 7. 🛡️ Xử lý lỗi toàn diện

Tất cả các lỗi được kiểm tra:

```swift
do {
    let result = try converter.convert(amount: -100, from: .VND, to: .USD, choose: .standard)
} catch CurrenciesError.invalidAmount(let msg) {
    print("Lỗi: \(msg)")  // "Amount must be >= 0, got -100"
} catch CurrenciesError.invalidExchangeRates(let rate) {
    print("Tỷ giá không hợp lệ: \(rate)")
} catch CurrenciesError.unsupportedConversion(let from, let to) {
    print("Chưa hỗ trợ \(from) → \(to)")
}
```

**Các lỗi có thể xảy ra:**
- ❌ Số tiền âm
- ❌ Tỷ giá <= 0
- ❌ Cặp tiền tệ không hỗ trợ

---

### 8. 📱 Tương thích đầy đủ

- ✅ **iOS**: 15.0+
- ✅ **macOS**: 12.0+
- ✅ **Swift**: 6.0+
- ✅ **Xcode**: 16.0+

---

### 9. 🔒 Bảo mật & Hiệu suất

- ✅ Zero network calls (tất cả xử lý local)
- ✅ Không lưu data gì trên device
- ✅ Pure Swift, không có C/Objective-C
- ✅ XCFramework binary (ẩn implementation)

---

**Tiếp theo:** [Developer Tools](DEVELOPER_TOOLS.md)
