# Welcome to transferMoney SDK

**transferMoney SDK** là một thư viện Swift nhẹ, mạnh mẽ giúp bạn dễ dàng chuyển đổi tiền tệ giữa VND (Đồng Việt Nam), USD (Đô la Mỹ), và AUD (Đô la Úc).

## Tại sao chọn transferMoney SDK?

### 🚀 Đơn giản & Nhanh
Chỉ 3 dòng code để convert tiền:
```swift
let converter = TransferMoney_core()
let result = try converter.convert(amount: 1_000_000, from: .VND, to: .USD, choose: .standard)
print(result.targetAmount)  // 39.29 USD
```

### 📦 Nhẹ & Không phụ thuộc
- Không cần API call
- Không cần kết nối internet
- Pure Swift, zero dependencies

### 🔒 Hoàn toàn kiểm soát
- Tỷ giá mặc định hoặc tuỳ chỉnh
- Độ chính xác thập phân tuỳ chọn
- Tất cả xử lý local trong device

### ✅ Đã kiểm thử kỹ
- 17 test cases comprehensive
- 100% Swift code
- Hỗ trợ iOS 15+ & macOS 12+

---

## Bắt đầu nhanh

### 1️⃣ Installation
```swift
// Package.swift
.package(url: "https://github.com/RumVu/transferMoney_SDK.git", from: "0.0.4")
```

### 2️⃣ Import
```swift
import transferMoney_SDK
```

### 3️⃣ Convert
```swift
let converter = TransferMoney_core()
let usd = try converter.vndToUsd(1_000_000)  // ≈ 39.29
```

---

## Các tính năng chính

- ✅ **6 conversion paths**: VND ↔ USD, USD ↔ AUD, VND ↔ AUD
- ✅ **Custom rates**: Update tỷ giá bất kỳ lúc nào
- ✅ **Precise calculations**: Làm tròn chính xác
- ✅ **Well documented**: DocC + examples
- ✅ **Fully tested**: 17 test cases pass 100%
- ✅ **Binary distribution**: XCFramework ready

---

## Tiếp theo

👉 **[Features](FEATURES.md)** — Xem chi tiết các tính năng

👉 **[Developer Tools](DEVELOPER_TOOLS.md)** — Hướng dẫn development

👉 **[API Reference](API_REFERENCE.md)** — Tài liệu API chi tiết

👉 **[Examples](EXAMPLES.md)** — Ví dụ code thực tế

👉 **[FAQ](FAQ.md)** — Câu hỏi thường gặp
