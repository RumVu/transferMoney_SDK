# Developer Tools

## Các công cụ & hướng dẫn development cho transferMoney SDK

### 1. 📦 Installation

#### Cách 1: Swift Package Manager (Khuyến khích)

**Trong Xcode:**
1. File → Add Packages
2. Nhập: `https://github.com/RumVu/transferMoney_SDK.git`
3. Chọn version: `0.0.4` or later
4. Add to project

**Trong Package.swift:**
```swift
.package(url: "https://github.com/RumVu/transferMoney_SDK.git", from: "0.0.4")
```

#### Cách 2: XCFramework (Binary Distribution)

```bash
# Download xcframework
wget https://github.com/RumVu/transferMoney_SDK/releases/download/v0.0.4/transferMoney_SDK.xcframework.zip

# Extract
unzip transferMoney_SDK.xcframework.zip

# Add to Xcode project
# Drag & drop vào project, hoặc Build Phases → Link Binary With Libraries
```

---

### 2. 🔨 Build & Test

#### Chạy tests

```bash
cd /path/to/transferMoney_SDK
swift test
```

**Output:**
```
Test Suite 'transferMoney_SDKTests' passed at 2026-04-17 10:30:45.xxx.
	 Executed 17 tests, with 0 failures (0 unexpected)
```

#### Build documentation

```bash
swift package --allow-writing-to-directory ./docs \
    generate-documentation \
    --target transferMoney_SDK \
    --output-path ./docs \
    --transform-for-static-hosting \
    --hosting-base-path transferMoney_SDK
```

#### Build XCFramework

```bash
./build_xcframework.sh
```

Output: `transferMoney_SDK.xcframework/`

---

### 3. 🚀 Release Process

#### Tự động release version mới

```bash
./release.sh 0.0.5
```

Script sẽ tự động:
1. ✅ Update version trong source + tests
2. ✅ Chạy tests (fail = dừng)
3. ✅ Commit: `Release v0.0.5`
4. ✅ Tag: `v0.0.5`
5. ✅ Push to GitHub

#### Tạo GitHub Release (thủ công)

1. Vào: https://github.com/RumVu/transferMoney_SDK/releases/new
2. Chọn tag: `v0.0.5`
3. Thêm release notes
4. Click "Publish"

---

### 4. 📝 Cấu trúc Project

```
transferMoney_SDK/
├── Sources/
│   └── transferMoney_SDK/
│       ├── transferMoney_SDK.swift       # Main SDK namespace
│       ├── Core/
│       │   └── TransferMoney_core.swift  # Core converter class
│       └── Model/
│           ├── Currency.swift
│           ├── ConversionConfigs.swift
│           ├── ConversionResults.swift
│           ├── ConversionOption.swift
│           └── CurrenciesError.swift
├── Tests/
│   └── transferMoney_SDKTests/
│       └── transferMoney_SDKTests.swift  # 17 test cases
├── Package.swift                        # SPM configuration
├── README.md                            # Getting started
├── CHANGELOG.md                         # Version history
└── docs/                                # Documentation
```

---

### 5. 🧪 Testing

#### Chạy tests cụ thể

```bash
# Run 1 test
swift test -t transferMoney_SDKTests.transferMoney_SDKTests.testVNDToUSD_2MillionVND

# Run tất cả VND tests
swift test -t transferMoney_SDKTests -k VND
```

#### Code coverage

```bash
swift test --enable-code-coverage
```

#### 17 Test Cases

| Tên | Mục đích |
|-----|---------|
| `testSDKVersion` | Kiểm tra version string |
| `testVNDToUSD_2MillionVND` | VND → USD conversion |
| `testVNDToUSD_zeroVND` | Zero amount handling |
| `testVNDToUSD_shorthand` | vndToUsd() method |
| `testVNDToUSD_customRate` | Custom rate option |
| `testUSDToVND_20USD` | USD → VND conversion |
| `testUSDToVND_shorthand` | usdToVnd() method |
| `testVNDToAUD_standard` | VND → AUD conversion |
| `testVNDToAUD_zeroAmount` | VND → AUD with 0 |
| `testUSDToAUD_10USD` | USD → AUD conversion |
| `testAUDToUSD_50AUD` | AUD → USD conversion |
| `testAUDToVND_20AUD` | AUD → VND conversion |
| `testNegativeAmountThrows` | Error: negative amount |
| `testCustomRateInvalidThrows` | Error: invalid rate |
| `testInvalidRateThrows` | Error: updateExchangeRates |
| `testResultContainsSDKVersion` | Result has version |
| `testResultTimestampIsRecent` | Result has timestamp |

---

### 6. 📚 Documentation Tools

#### DocC (Auto-generated docs)

```bash
# Preview locally
swift package preview-documentation --target transferMoney_SDK
```

#### Markdown Docs

- `docs/WELCOME.md` - Getting started
- `docs/FEATURES.md` - Feature overview
- `docs/DEVELOPER_TOOLS.md` - This file
- `docs/API_REFERENCE.md` - API details
- `docs/EXAMPLES.md` - Code examples
- `docs/FAQ.md` - Q&A

---

### 7. 🔍 Debugging Tips

#### Enable debug logging

```swift
let config = ConversionConfigs(VNDtoUSDRate: 25_450, decimalPrecision: 6)
let converter = TransferMoney_core(config: config)

// Check current config
print(converter.config.VNDtoUSDRate)          // 25450.0
print(converter.config.decimalPrecision)      // 6
```

#### Inspect results

```swift
let result = try converter.convert(amount: 1_000_000, from: .VND, to: .USD, choose: .standard)

print("Source: \(result.sourceAmount) \(result.sourceCurrency.rawValue)")
print("Target: \(result.targetAmount) \(result.targetCurrency.rawValue)")
print("Rate: \(result.exchangeRate)")
print("SDK: \(result.sdkVersion)")
print("Time: \(result.timeStamp)")
```

#### Enum values

```swift
// List all currencies
for currency in Currency.allCases {
    print("\(currency.rawValue) - \(currency.displayName) (\(currency.symbol))")
}
// Output:
// VND - VietNam Dong (đ)
// USD - Dollar ($)
// AUD - Australian Dollar (A$)
```

---

### 8. 📦 Distribution

#### Binary Framework (XCFramework)

Advantages:
- ✅ Hide implementation
- ✅ Smaller downloads
- ✅ Faster compilation
- ✅ Obfuscated code

Build:
```bash
./build_xcframework.sh
```

#### Source Distribution

Just use SPM:
```swift
.package(url: "https://github.com/RumVu/transferMoney_SDK.git")
```

---

### 9. 🐛 Troubleshooting

| Vấn đề | Giải pháp |
|--------|----------|
| Import failed | Kiểm tra Package.swift `target` name |
| Test failed | Run `swift package clean` |
| Version mismatch | Check version string trong code |
| Build slow | Enable `SKIP_INSTALL=YES` |

---

### 10. 📞 Support

- **GitHub Issues**: https://github.com/RumVu/transferMoney_SDK/issues
- **Documentation**: https://rumvu.github.io/transferMoney_SDK/
- **Swift Package Index**: https://swiftpackageindex.com/RumVu/transferMoney_SDK

---

**Tiếp theo:** [API Reference](API_REFERENCE.md)
