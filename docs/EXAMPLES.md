# Examples

## Các ví dụ thực tế sử dụng transferMoney SDK

---

## 1️⃣ Cơ bản: VND to USD

```swift
import transferMoney_SDK

let converter = TransferMoney_core()

// Chuyển 1 triệu VND sang USD
let result = try converter.convert(
    amount: 1_000_000,
    from: .VND,
    to: .USD,
    choose: .standard
)

print("₫\(result.sourceAmount) = $\(result.targetAmount)")
// ₫1000000.0 = $39.2926...
```

---

## 2️⃣ Shorthand Methods

```swift
// Nhanh gọn - chỉ cần số tiền
let usd = try converter.vndToUsd(2_000_000)
// usd ≈ 78.58

let vnd = try converter.usdToVnd(100)
// vnd = 2,545,000
```

---

## 3️⃣ Custom Exchange Rate

```swift
// Đôi khi bạn muốn dùng tỷ giá khác
let blackMarketRate = 26_000  // Tỷ giá chợ đen

let result = try converter.convert(
    amount: 1_000_000,
    from: .VND,
    to: .USD,
    choose: .customRate(blackMarketRate)
)

print(result.targetAmount)  // 38.46 (cao hơn tỷ giá chính thức)
```

---

## 4️⃣ USD to AUD

```swift
// Khách hàng Úc muốn biết giá USD thành AUD
let result = try converter.convert(
    amount: 100,
    from: .USD,
    to: .AUD,
    choose: .standard
)

print("$100 USD = A$\(result.targetAmount)")
// $100 USD = A$63.0
```

---

## 5️⃣ AUD to VND (Multi-step)

```swift
// Tự động convert qua USD trung gian
let result = try converter.convert(
    amount: 50,
    from: .AUD,
    to: .VND,
    choose: .standard
)

print("A$50 = ₫\(result.targetAmount)")
// A$50 = ₫2,018,750.0

// Effective rate: AUD/VND
print("Effective rate: \(result.exchangeRate)")
// 40375.0 (VND per AUD)
```

---

## 6️⃣ Formatted Output for UI

```swift
let result = try converter.convert(
    amount: 1_500_000,
    from: .VND,
    to: .USD,
    choose: .standard
)

// Sẵn có string định dạng cho UI
print(result.FormattedSourceAmount)  // "₫ 1,500,000.00"
print(result.FormattedTargetAmount)  // "$ 58.9389"

// Hoặc format tùy ý
let formatter = NumberFormatter()
formatter.numberStyle = .currency
formatter.currencyCode = "USD"
print(formatter.string(from: NSNumber(value: result.targetAmount)))
// $58.94
```

---

## 7️⃣ Error Handling

```swift
do {
    // ❌ Số tiền âm
    let result1 = try converter.convert(
        amount: -1_000_000,
        from: .VND,
        to: .USD,
        choose: .standard
    )
} catch CurrenciesError.invalidAmount(let msg) {
    print("Invalid amount: \(msg)")
    // "Amount must be >= 0, got -1000000"
}

do {
    // ❌ Tỷ giá không hợp lệ
    let result2 = try converter.convert(
        amount: 1_000_000,
        from: .VND,
        to: .USD,
        choose: .customRate(-25_000)  // Rate âm!
    )
} catch CurrenciesError.invalidExchangeRates(let rate) {
    print("Invalid rate: \(rate)")  // -25000.0
}

do {
    // ❌ Conversion không hỗ trợ (nếu có)
    // Hiện tại tất cả cặp đều hỗ trợ, nhưng phòng trường hợp
    let result3 = try converter.convert(
        amount: 100,
        from: .VND,
        to: .VND,  // Same → Same OK
        choose: .standard
    )
} catch CurrenciesError.unsupportedConversion(let from, let to) {
    print("Not supported: \(from) → \(to)")
}
```

---

## 8️⃣ Update Exchange Rates

```swift
// Tỷ giá mặc định
var rate = try converter.vndToUsd(1_000_000)  // 39.29

// Cập nhật tỷ giá vào lúc chạy
try converter.updateExchangeRates(26_000)

// Lần convert tiếp theo sẽ dùng rate mới
rate = try converter.vndToUsd(1_000_000)  // 38.46

// Hoặc custom rate cho 1 lần duy nhất
let resultCustom = try converter.convert(
    amount: 1_000_000,
    from: .VND,
    to: .USD,
    choose: .customRate(27_000)  // Rate tạm thời
)

// Cấu hình không thay đổi
rate = try converter.vndToUsd(1_000_000)  // Vẫn 38.46 (rate từ updateExchangeRates)
```

---

## 9️⃣ Custom Precision

```swift
// Mặc định: 6 chữ số thập phân
let config1 = ConversionConfigs()
let converter1 = TransferMoney_core(config: config1)
let result1 = try converter1.convert(
    amount: 1_000_000,
    from: .VND,
    to: .USD,
    choose: .standard
)
print(result1.targetAmount)  // 39.292063...

// 2 chữ số: cho tiền tệ
let config2 = ConversionConfigs(decimalPrecision: 2)
let converter2 = TransferMoney_core(config: config2)
let result2 = try converter2.convert(
    amount: 1_000_000,
    from: .VND,
    to: .USD,
    choose: .standard
)
print(result2.targetAmount)  // 39.29

// 0 chữ số: làm tròn thành số nguyên
let config3 = ConversionConfigs(decimalPrecision: 0)
let converter3 = TransferMoney_core(config: config3)
let result3 = try converter3.convert(
    amount: 1_000_000,
    from: .VND,
    to: .USD,
    choose: .standard
)
print(result3.targetAmount)  // 39.0
```

---

## 🔟 Real-world: E-commerce Cart

```swift
// Cửa hàng online hiển thị giá USD nhưng nhập liệu VND

struct Product {
    let name: String
    let priceVND: Double
}

let products = [
    Product(name: "Laptop", priceVND: 25_000_000),
    Product(name: "Mouse", priceVND: 500_000),
    Product(name: "Keyboard", priceVND: 1_500_000)
]

let converter = TransferMoney_core()

for product in products {
    let usdPrice = try converter.vndToUsd(product.priceVND)
    let formatted = String(format: "%.2f", usdPrice)
    print("\(product.name): ₫\(product.priceVND) = \$\(formatted) USD")
}

// Output:
// Laptop: ₫25000000 = $981.70 USD
// Mouse: ₫500000 = $19.63 USD
// Keyboard: ₫1500000 = $58.89 USD
```

---

## 1️⃣1️⃣ Real-world: Travel Budget

```swift
// Du khách dự tính chi phí chuyến đi

struct TravelPlan {
    let hotel: Double      // USD
    let food: Double       // USD
    let transport: Double  // USD
    let misc: Double       // USD
    
    var total: Double {
        hotel + food + transport + misc
    }
}

let plan = TravelPlan(
    hotel: 150,      // $150/night
    food: 50,        // $50/day
    transport: 200,  // $200 total
    misc: 100        // $100 other
)

let converter = TransferMoney_core()
let budgetVND = try converter.usdToVnd(plan.total)

print("Total budget: $\(plan.total) = ₫\(Int(budgetVND)):,00")
// Total budget: $500 = ₫12,725,000.00
```

---

## 1️⃣2️⃣ Real-world: Multi-currency Invoice

```swift
// Hóa đơn có tiền tệ khác nhau

struct Invoice {
    let vndAmount: Double
    let usdAmount: Double
    let audAmount: Double
}

let invoice = Invoice(
    vndAmount: 10_000_000,
    usdAmount: 500,
    audAmount: 0  // Chưa biết
)

let converter = TransferMoney_core()

// Tính AUD từ USD
let audAmount = try converter.convert(
    amount: invoice.usdAmount,
    from: .USD,
    to: .AUD,
    choose: .standard
).targetAmount

print("Invoice:")
print("- VND: \(invoice.vndAmount)")
print("- USD: \(invoice.usdAmount)")
print("- AUD: \(audAmount)")

// Kiểm tra tổng cộng (convert tất cả về VND)
let vndTotal = try converter.vndToUsd(invoice.vndAmount) +
               Double(invoice.usdAmount) +
               try converter.convert(amount: audAmount, from: .AUD, to: .USD, choose: .standard).targetAmount

print("Total in USD: $\(vndTotal)")
```

---

## 1️⃣3️⃣ Testing & Verification

```swift
// Verify conversion accuracy
let converter = TransferMoney_core()

// Test 1: Tính ngược
let original = 1_000_000.0
let toUSD = try converter.vndToUsd(original)
let back = try converter.usdToVnd(toUSD)

print("Original: \(original)")
print("To USD & Back: \(back)")
// Sẽ có sai số do làm tròn, nhưng rất nhỏ

// Test 2: Verify rates
print("1 USD = \(converter.config.VNDtoUSDRate) VND")
print("1 AUD = \(converter.config.AUDtoUSDRate) USD")

// Test 3: Zero amounts
let zeroResult = try converter.convert(
    amount: 0,
    from: .VND,
    to: .USD,
    choose: .standard
)
assert(zeroResult.targetAmount == 0, "Zero should remain zero")
```

---

**Tiếp theo:** [FAQ](FAQ.md)
