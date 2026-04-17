# FAQ

## Câu hỏi thường gặp (Frequently Asked Questions)

---

## ❓ Cơ bản

### Q1: transferMoney SDK là gì?

**A:** Thư viện Swift nhẹ để chuyển đổi tiền tệ giữa VND, USD, và AUD. Tất cả xử lý local, không cần API call hay internet.

---

### Q2: Có cần internet không?

**A:** Không. Converter hoạt động hoàn toàn offline. Tỷ giá được hardcode, bạn update thủ công nếu cần.

---

### Q3: Tỷ giá có real-time không?

**A:** Không. Tỷ giá mặc định là:
- VND/USD: 25,450
- AUD/USD: 0.63

Bạn có thể update bằng `updateExchangeRates()` hoặc dùng `customRate()`.

---

### Q4: Có fee hay commission không?

**A:** Không. Converter chỉ nhân/chia theo tỷ giá, không có thêm fee nào.

---

### Q5: Precision là gì?

**A:** Số chữ số thập phân dùng để làm tròn kết quả.
- Mặc định: 6 chữ số
- Có thể đổi: `ConversionConfigs(decimalPrecision: 2)`

---

## 🔧 Installation & Setup

### Q6: Cách cài đặt?

**A:** Dùng Swift Package Manager:

```swift
// Package.swift
.package(url: "https://github.com/RumVu/transferMoney_SDK.git", from: "0.0.4")
```

Hoặc trong Xcode: File → Add Packages

---

### Q7: Yêu cầu iOS/macOS version?

**A:** 
- iOS 15.0+
- macOS 12.0+
- Swift 6.0+

---

### Q8: Có phiên bản Objective-C không?

**A:** Không. Pure Swift only.

---

### Q9: Hỗ trợ Linux không?

**A:** Hiện tại chưa test trên Linux. Nếu bạn cần, mở issue trên GitHub.

---

## 💱 Conversion & Rates

### Q10: Tại sao kết quả không chính xác?

**A:** Có thể vì:
1. Làm tròn thập phân (precision)
2. Tỷ giá lạc hậu so với thị trường
3. Sai số floating point

Nếu cần chính xác hơn, tăng `decimalPrecision`.

---

### Q11: Cách update tỷ giá?

**A:** 
```swift
// Cách 1: Update tỷ giá mặc định
try converter.updateExchangeRates(26_000)

// Cách 2: Custom rate cho 1 lần
let result = try converter.convert(
    amount: 1_000_000,
    from: .VND,
    to: .USD,
    choose: .customRate(26_000)
)
```

---

### Q12: AUD/USD rate mặc định 0.63 đúng không?

**A:** Gần đúng, nhưng market thay đổi. Bạn có thể update bất kỳ lúc nào bằng cách chỉnh `ConversionConfigs`.

---

### Q13: Có hỗ trợ currency nào khác không?

**A:** Hiện tại chỉ: VND, USD, AUD.

Nếu bạn cần currency khác (EUR, GBP, JPY...), mở issue trên GitHub.

---

### Q14: Same currency conversion (VND → VND) có được không?

**A:** Có. Sẽ trả về đúng số tiền đó với rate = 1.0.

```swift
let result = try converter.convert(
    amount: 1_000_000,
    from: .VND,
    to: .VND,
    choose: .standard
)
// result.targetAmount = 1000000.0
// result.exchangeRate = 1.0
```

---

## ⚠️ Errors & Troubleshooting

### Q15: "Amount must be >= 0" error?

**A:** Bạn nhập số tiền âm. Kiểm tra input:

```swift
if amount >= 0 {
    let result = try converter.convert(amount: amount, ...)
}
```

---

### Q16: "Invalid exchange rate" error?

**A:** Tỷ giá <= 0. Kiểm tra code:

```swift
try converter.updateExchangeRates(25_450)  // ✅ OK
try converter.updateExchangeRates(0)       // ❌ Error
try converter.updateExchangeRates(-25_450) // ❌ Error
```

---

### Q17: "Unsupported conversion" error?

**A:** Cặp tiền không hỗ trợ. Kiểm tra conversion path:

```swift
// Hỗ trợ:
.VND → .USD, .USD → .VND
.USD → .AUD, .AUD → .USD
.VND → .AUD, .AUD → .VND

// Không hỗ trợ (hiện tại):
// Không có cặp khác ngoài trên
```

---

### Q18: Test failed, sao?

**A:** Thử:
```bash
swift package clean
swift test
```

Nếu vẫn fail, check version match và Swift version.

---

## 📊 Results & Output

### Q19: Result structure là gì?

**A:** `ConversionResults` có:
- `sourceAmount`: Số tiền gốc
- `sourceCurrency`: Loại tiền gốc
- `targetAmount`: Số tiền chuyên đổi
- `targetCurrency`: Loại tiền đích
- `exchangeRate`: Tỷ giá dùng
- `sdkVersion`: Phiên bản SDK
- `timeStamp`: Thời gian convert
- `FormattedSourceAmount`: String định dạng
- `FormattedTargetAmount`: String định dạng

---

### Q20: Cách format result cho UI?

**A:** Dùng computed properties hoặc NumberFormatter:

```swift
// Cách 1: SDK cung cấp sẵn
print(result.FormattedTargetAmount)  // "$ 39.2927"

// Cách 2: Custom format
let formatter = NumberFormatter()
formatter.numberStyle = .currency
formatter.currencyCode = "USD"
formatter.string(from: NSNumber(value: result.targetAmount))
// "$39.29"
```

---

### Q21: Timestamp dùng để làm gì?

**A:** Để biết lúc nào convert được thực hiện. Có thể dùng để:
- Log & audit trail
- Cache invalidation
- Rate freshness check

```swift
let result = try converter.convert(...)
print(result.timeStamp)  // 2026-04-17 10:30:45
```

---

## 🚀 Advanced

### Q22: Cách integrate vào project lớn?

**A:** Best practices:
1. Create singleton hoặc Dependency Injection
2. Cache converter instance
3. Handle errors properly
4. Log conversions

```swift
class CurrencyService {
    static let shared = CurrencyService()
    private let converter = TransferMoney_core()
    
    func convert(_ amount: Double, from: Currency, to: Currency) throws -> Double {
        let result = try converter.convert(amount: amount, from: from, to: to, choose: .standard)
        print("[Currency] \(amount) \(from.rawValue) → \(result.targetAmount) \(to.rawValue)")
        return result.targetAmount
    }
}

// Usage
let usd = try CurrencyService.shared.convert(1_000_000, from: .VND, to: .USD)
```

---

### Q23: Performance / efficiency?

**A:** Converter rất nhẹ:
- Khởi tạo: <1ms
- Convert: <0.1ms
- Memory: ~1KB

Bạn có thể tạo nhiều instance mà không lo performance.

---

### Q24: Thread-safe?

**A:** Converter có `private(set) var config`, nên không thread-safe nếu bạn update rate từ nhiều thread.

Khuyến khích:
```swift
// Dùng lock nếu multi-threaded
let lock = NSLock()
lock.lock()
try converter.updateExchangeRates(newRate)
lock.unlock()
```

---

### Q25: XCFramework là gì?

**A:** Binary distribution format. Ẩn source code, chỉ cung cấp compiled framework.

Lợi ích:
- Ẩn implementation
- Tăng bảo mật
- Giảm build time

Hạn chế:
- Khó debug
- Bound to Swift version

---

## 🔐 Security & Privacy

### Q26: Dữ liệu có được lưu không?

**A:** Không. Converter chỉ tính toán, không lưu dữ liệu.

---

### Q27: API key hay credentials được cần?

**A:** Không. Offline-first, không API calls.

---

### Q28: Có tracking hay analytics không?

**A:** Không. Zero telemetry.

---

## 📦 Distribution & Releases

### Q29: Cách cập nhật lên version mới?

**A:** Dùng release script:

```bash
./release.sh 0.0.5
```

---

### Q30: Khi nào nên major vs minor version?

**A:** Semantic versioning:
- **Major** (1.0.0): Breaking changes (API thay đổi)
- **Minor** (0.1.0): New features (backward compatible)
- **Patch** (0.0.1): Bug fixes

transferMoney SDK hiện ở v0.0.x (pre-release), nên mọi thay đổi đều có thể breaking.

---

## 📝 Documentation & Support

### Q31: Có more examples?

**A:** Xem [Examples.md](EXAMPLES.md) file.

---

### Q32: API reference đầy đủ ở đâu?

**A:** [API_REFERENCE.md](API_REFERENCE.md)

---

### Q33: Cách report bug?

**A:** GitHub Issues: https://github.com/RumVu/transferMoney_SDK/issues

---

### Q34: Có Slack/Discord community không?

**A:** Hiện tại chưa. Vui lòng dùng GitHub Issues.

---

### Q35: Cách contribute code?

**A:** 
1. Fork repo
2. Create feature branch
3. Make changes + add tests
4. Submit PR

Xem CONTRIBUTING.md (nếu có).

---

## 🎓 Learning & Education

### Q36: Cách dùng cho học tập?

**A:** Converter simple & well-documented, tốt cho học:
- Swift generics
- Error handling
- Unit testing
- Documentation (DocC)
- Package distribution

---

### Q37: Source code có comment không?

**A:** Có. DocC comments cho tất cả public API + implementation comments.

---

### Q38: Có architecture pattern nào?

**A:** 
- **Private extension pattern**: Logic ẩn trong private extension
- **Enum cases**: Type-safe error handling
- **Config object**: Dependency injection

---

## 🤔 Other

### Q39: Tại sao chỉ VND, USD, AUD?

**A:** MVP (Minimum Viable Product) focus vào tiền tệ phổ biến ở Đông Á & Úc.

---

### Q40: Có roadmap không?

**A:** Sắp tới:
- [ ] Thêm EUR, GBP, JPY
- [ ] Real-time rates từ API
- [ ] Offline cache
- [ ] Widget support

---

## 📚 Resources

- **GitHub**: https://github.com/RumVu/transferMoney_SDK
- **Documentation**: https://rumvu.github.io/transferMoney_SDK/
- **Swift Package Index**: https://swiftpackageindex.com/RumVu/transferMoney_SDK
- **Issues**: https://github.com/RumVu/transferMoney_SDK/issues

---

**Không tìm được câu trả lời?** Mở issue trên GitHub!
