# Releases & Version Selection

## 📦 Download Specific Version

### Swift Package Manager (Recommended)

#### Latest Version (Recommended)
```swift
// Package.swift
.package(url: "https://github.com/RumVu/transferMoney_SDK.git", from: "0.0.6")
```

Or in Xcode:
1. File → Add Packages
2. Enter: `https://github.com/RumVu/transferMoney_SDK.git`
3. Select "Up to Next Major" (default)
4. Click "Add Package"

---

#### Specific Version (Pinned)
```swift
// Package.swift
.package(url: "https://github.com/RumVu/transferMoney_SDK.git", exact: "0.0.4")
```

Or in Xcode:
1. File → Add Packages
2. Enter URL
3. Select "Exact" instead of "Up to Next Major"
4. Enter specific version (e.g., `0.0.4`)
5. Click "Add Package"

---

#### Version Range
```swift
// Any version from 0.0.3 to (but not including) 0.1.0
.package(url: "https://github.com/RumVu/transferMoney_SDK.git", from: "0.0.3")

// Any version from 0.0.2 to 0.0.5
.package(url: "https://github.com/RumVu/transferMoney_SDK.git", "0.0.2"..<"0.0.6")

// Revision/Branch specific
.package(url: "https://github.com/RumVu/transferMoney_SDK.git", .branch("main"))
```

---

### XCFramework (Binary)

Download from GitHub Releases:

```bash
# Download specific version
wget https://github.com/RumVu/transferMoney_SDK/releases/download/v0.0.4/transferMoney_SDK.xcframework.zip

# Extract
unzip transferMoney_SDK.xcframework.zip

# Add to Xcode project
# Drag & drop into project or Build Phases → Link Binary With Libraries
```

---

## 🏷️ All Available Versions

### Current Releases

| Version | Date | Downloads | Status | Notes |
|---------|------|-----------|--------|-------|
| **0.0.6** | 2026-04-17 | [Latest](https://github.com/RumVu/transferMoney_SDK/releases/tag/v0.0.6) | ✅ Latest | Comprehensive docs + 5 guides |
| **0.0.5** | 2026-04-17 | [v0.0.5](https://github.com/RumVu/transferMoney_SDK/releases/tag/v0.0.5) | ✅ Stable | Release automation script |
| **0.0.4** | 2026-04-16 | [v0.0.4](https://github.com/RumVu/transferMoney_SDK/releases/tag/v0.0.4) | ✅ Stable | Complete AUD support |
| **0.0.3** | 2026-04-16 | [v0.0.3](https://github.com/RumVu/transferMoney_SDK/releases/tag/v0.0.3) | ✅ Stable | AUD + new API |
| **0.0.2** | 2026-04-16 | [v0.0.2](https://github.com/RumVu/transferMoney_SDK/releases/tag/v0.0.2) | ⚠️ Old | Binary distribution |
| **0.0.1** | 2026-04-16 | [v0.0.1](https://github.com/RumVu/transferMoney_SDK/releases/tag/v0.0.1) | ⚠️ Old | Initial MVP |

---

## 🔄 Migration Guide

### From v0.0.1 → v0.0.2
**No code changes needed** - Compatible upgrade
```swift
let converter = TransferMoney_core()  // Still works
let result = try converter.convert(amount: 1_000_000, from: .VND, to: .USD, standardRate: true)
```

---

### From v0.0.2 → v0.0.3 ⚠️ BREAKING
**API changed** - Code update required

**Before (v0.0.2):**
```swift
try converter.convert(amount: 1_000_000, from: .VND, to: .USD, standardRate: true)
try converter.convert(amount: 1_000_000, from: .VND, to: .USD, standardRate: false)
```

**After (v0.0.3+):**
```swift
try converter.convert(amount: 1_000_000, from: .VND, to: .USD, choose: .standard)
try converter.convert(amount: 1_000_000, from: .VND, to: .USD, choose: .customRate(25_800))
```

**What changed:**
- `standardRate: Bool` → `choose: ConversionOption`
- `.standard` - Use default rates
- `.customRate(Double)` - Use custom rate

---

### From v0.0.3 → v0.0.4
**No code changes needed** - Backward compatible
- Added new conversion paths (USD ↔ AUD, AUD ↔ VND)
- Existing code works as before
- New features available if needed

---

### From v0.0.4 → v0.0.5
**No code changes needed** - Backward compatible
- Added release automation tools
- Docs added
- No API changes

---

### From v0.0.5 → v0.0.6
**No code changes needed** - Backward compatible
- Documentation expanded
- No API changes
- All existing code works

---

## 🚀 Feature by Version

### Currency Support
| Feature | v0.0.1 | v0.0.2 | v0.0.3 | v0.0.4 | v0.0.5 | v0.0.6 |
|---------|--------|--------|--------|--------|--------|--------|
| VND ↔ USD | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| VND → AUD | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ |
| AUD → VND | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ |
| USD ↔ AUD | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ |

### API Features
| Feature | v0.0.1 | v0.0.2 | v0.0.3 | v0.0.4 | v0.0.5 | v0.0.6 |
|---------|--------|--------|--------|--------|--------|--------|
| `convert()` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| `vndToUsd()` shorthand | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ |
| `usdToVnd()` shorthand | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ |
| Custom rates | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ |
| ConversionOption | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ |

### Quality & Documentation
| Feature | v0.0.1 | v0.0.2 | v0.0.3 | v0.0.4 | v0.0.5 | v0.0.6 |
|---------|--------|--------|--------|--------|--------|--------|
| Tests | 10 | 10 | 14 | 17 | 17 | 17 |
| DocC | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ |
| README | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ |
| API Docs | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| Examples | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| FAQ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| Release Tool | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ |

### Binary Distribution
| Feature | v0.0.1 | v0.0.2 | v0.0.3 | v0.0.4 | v0.0.5 | v0.0.6 |
|---------|--------|--------|--------|--------|--------|--------|
| XCFramework | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ |
| GitHub Actions | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ |
| SPM Ready | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

---

## 📊 Version Comparison

### Use v0.0.1 if:
- ❌ Not recommended (old MVP)

### Use v0.0.2 if:
- You need binary framework
- ⚠️ Limited documentation

### Use v0.0.3 if:
- You want AUD support
- ⚠️ Larger than v0.0.2

### Use v0.0.4 if:
- You need all 6 conversion paths
- ⚠️ Want stable AUD support

### Use v0.0.5 if:
- You want release automation
- ⚠️ Still limited docs

### Use v0.0.6 ✅ RECOMMENDED
- ✅ Latest & most stable
- ✅ Complete documentation
- ✅ 40+ Q&A answers
- ✅ 13 code examples
- ✅ Professional API docs
- ✅ All 6 conversion paths

---

## 📥 Quick Install Commands

```bash
# Latest version (recommended)
.package(url: "https://github.com/RumVu/transferMoney_SDK.git", from: "0.0.6")

# Specific version (e.g., v0.0.4)
.package(url: "https://github.com/RumVu/transferMoney_SDK.git", exact: "0.0.4")

# Latest in 0.0.x range
.package(url: "https://github.com/RumVu/transferMoney_SDK.git", from: "0.0.0")

# Clone specific version
git clone https://github.com/RumVu/transferMoney_SDK.git
git checkout v0.0.4
```

---

## 🔗 Links

- **Latest Release**: https://github.com/RumVu/transferMoney_SDK/releases/latest
- **All Releases**: https://github.com/RumVu/transferMoney_SDK/releases
- **GitHub Tags**: https://github.com/RumVu/transferMoney_SDK/tags
- **Swift Package Index**: https://swiftpackageindex.com/RumVu/transferMoney_SDK

---

## ❓ FAQ

### Q: Which version should I use?
**A:** Use **v0.0.6** (latest) unless you have specific compatibility needs.

### Q: Is v0.0.3 breaking?
**A:** Yes, the API changed from `standardRate: Bool` to `choose: ConversionOption`. See migration guide above.

### Q: Can I use v0.0.1?
**A:** Not recommended. Use v0.0.4+ for AUD support.

### Q: Is v0.0.6 stable?
**A:** Yes, all 17 tests pass. Recommended for production.

### Q: How do I downgrade versions?
**A:** Update your `Package.swift`:
```swift
// Change from:
.package(url: "...", from: "0.0.6")

// To:
.package(url: "...", exact: "0.0.4")
```

Then run: `swift package update`

---

**Last Updated:** 2026-04-17
