# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

---

## [0.0.6] - 2026-04-17

### Added
- **Comprehensive documentation** (5 markdown guides):
  - `docs/WELCOME.md` - Getting started guide
  - `docs/FEATURES.md` - Detailed feature overview
  - `docs/DEVELOPER_TOOLS.md` - Development & release guide
  - `docs/API_REFERENCE.md` - Complete API documentation
  - `docs/EXAMPLES.md` - 13 real-world code examples
  - `docs/FAQ.md` - 40 frequently asked questions
- Updated `.gitignore` to track documentation

### Documentation Structure
- Professional layout similar to Android & iOS docs
- Welcome section for quick start
- Features section with all capabilities
- Developer tools for build/test/release workflows
- Detailed API reference for every class/method
- Practical examples for common use cases
- FAQ covering all aspects (basic, installation, conversion, errors, etc.)

### Tests
- Total: 17 tests all passing
- All documentation verified with code examples

---

## [0.0.5] - 2026-04-17

### Added
- `release.sh` script for automated version releases
- `README.md` with comprehensive getting started guide
- `CHANGELOG.md` tracking version history

### Features in release.sh
- Automatic version number updates
- Test execution before release
- Automated git commit & tag
- Direct push to GitHub

### Benefits
- One-command releases: `./release.sh 0.0.6`
- No manual version number tracking
- Consistent release process
- Quick and error-free releases

### Tests
- Total: 17 tests all passing

---

## [0.0.4] - 2026-04-16

### Added
- **Complete bidirectional AUD support**:
  - USD ↔ AUD direct conversions
  - AUD → VND conversion (via USD intermediary)
  - AUD → USD conversion
- Extended documentation with AUD examples
- 3 new test cases for AUD conversions

### Supported Conversions (now 6 paths)
```
VND ↔ USD (direct)
USD ↔ AUD (direct)
VND ↔ AUD (via USD)
Same currency → Same (passthrough)
```

### Changes
- Updated class docstring to show all 6 conversion paths
- Enhanced code comments explaining multi-step conversions
- Improved documentation examples

### Tests
- Total: 17 tests all passing
- New tests:
  - `testUSDToAUD_10USD` - USD to AUD conversion
  - `testAUDToUSD_50AUD` - AUD to USD conversion
  - `testAUDToVND_20AUD` - AUD to VND via USD

---

## [0.0.3] - 2026-04-16

### Major Changes
- **New API design** with `ConversionOption` enum
- **Refactored code structure** with private extension methods
- **Added AUD currency support**

### Added
- `Currency.AUD` case
- `ConversionOption` enum with two cases:
  - `.standard` - Use default rates
  - `.customRate(Double)` - Use custom rate for single call
- `AUDtoUSDRate` in `TransferMoneySDK` (default: 0.63)
- `AUDtoUSDRate` in `ConversionConfigs`
- VND → AUD conversion (automatic via USD intermediary)
- Shorthand methods:
  - `vndToUsd(_ vnd: Double) -> Double`
  - `usdToVnd(_ usd: Double) -> Double`

### Changed
- **convert() method signature**:
  ```swift
  // Before (v0.0.2):
  func convert(amount: Double, from: Currency, to: Currency, standardRate: Bool) -> ConversionResults
  
  // After (v0.0.3):
  func convert(amount: Double, from: Currency, to: Currency, choose: ConversionOption) -> ConversionResults
  ```
- Refactored conversion logic into private methods
- Updated to use private extension pattern
- Improved code encapsulation

### Fixed
- **Module name collision**: Renamed `struct transferMoney_SDK` → `struct TransferMoneySDK`
  - Issue: Same name as module broke `BUILD_LIBRARY_FOR_DISTRIBUTION`
- **Property typos**:
  - `ConversionResults.exChangeRate` → `exchangeRate`
  - `ConversionResults.FormatteerSourceAmount` → `FormattedSourceAmount`
- **Error type**: `CurrenciesError.invaldAmount` → `invalidAmount`

### Tests
- Total: 14 tests passing (up from 10)
- New tests:
  - `testVNDToAUD_standard` - VND to AUD conversion
  - `testVNDToAUD_zeroAmount` - Edge case handling
  - `testVNDToUSD_customRate` - Custom rate option
  - `testCustomRateInvalidThrows` - Error handling for bad rates

### Breaking Changes ⚠️
- API changed from `standardRate: Bool` to `choose: ConversionOption`
- Old code must be updated:
  ```swift
  // Old (v0.0.2):
  try converter.convert(amount: 1_000_000, from: .VND, to: .USD, standardRate: true)
  
  // New (v0.0.3):
  try converter.convert(amount: 1_000_000, from: .VND, to: .USD, choose: .standard)
  ```

---

## [0.0.2] - 2026-04-16

### Major Focus: Binary Distribution & Documentation

### Added
- **XCFramework support**:
  - Added `type: .dynamic` to Package.swift
  - Enabled `BUILD_LIBRARY_FOR_DISTRIBUTION` flag
  - Created `build_xcframework.sh` script
- **GitHub Actions CI/CD**:
  - `.github/workflows/deploy-docs.yml`
  - Automatic DocC generation on every push
- **Enhanced code quality**:
  - Fixed struct name collision issue
  - Improved documentation comments
  - Better code organization

### Changed
- Updated `Package.swift`:
  - `swift-tools-version: 6.0` (from 5.10)
  - Added `type: .dynamic` for binary framework
  - Added `swiftLanguageModes: [.v6]`
  - Added `swift-docc-plugin` dependency
- Module name: `transferMoney_SDK` → `TransferMoneySDK` (to fix collision)

### Infrastructure
- **GitHub Pages deployment** for DocC
- **Automated documentation builds**
- **Binary framework distribution** ready
- **Swift Package Index compatible**

### Build Script
- `build_xcframework.sh` - One-command XCFramework building
  - Compiles for iOS device + iOS Simulator
  - Creates .xcframework bundle
  - Ready for distribution

### Documentation
- **DocC comments** for all public API
- **GitHub Pages** at rumvu.github.io/transferMoney_SDK
- **Auto-generated** on every commit to main

### Tests
- Total: 10 tests passing
- All tests updated with new API

### Benefits
- Developers can use SDK without seeing source code
- Binary distribution protects intellectual property
- Faster compilation for consumer projects
- Professional documentation hosting

---

## [0.0.1] - 2026-04-16

### Initial Release 🎉

Complete MVP (Minimum Viable Product) for currency conversion.

### Core Features
- **Currency Conversion**: VND ↔ USD (bidirectional)
- **Main Class**: `TransferMoney_core`
  - `convert(amount:from:to:standardRate:)` - Main method
  - `vndToUsd()` - Shorthand (v0.3+)
  - `usdToVnd()` - Shorthand (v0.3+)
- **Customization**: `ConversionConfigs`
  - Configurable exchange rates
  - Configurable decimal precision
- **Currency Enum**: Support VND & USD
  - `displayName` property
  - `symbol` property
  - `rawValue` property

### Types & Structures
- `TransferMoneySDK` - Static namespace with metadata
  - `version` - SDK version string
  - `defaultVNDToUSDRate` - 25,450.0
- `ConversionResults` - Result object with:
  - `sourceAmount`, `sourceCurrency`
  - `targetAmount`, `targetCurrency`
  - `exchangeRate`
  - `sdkVersion`, `timeStamp`
  - `FormattedSourceAmount`, `FormattedTargetAmount`
- `CurrenciesError` - Error handling:
  - `invalidAmount(String)`
  - `invalidExchangeRates(Double)`

### Test Coverage
- 10 comprehensive test cases
- VND → USD conversions
- USD → VND conversions
- Zero amount handling
- Error cases (negative amounts, invalid rates)
- Result validation (version, timestamp)

### Default Settings
- VND/USD Rate: 25,450
- Decimal Precision: 6 digits
- Error handling with detailed messages
- Timestamp tracking for all conversions

### Project Setup
- Swift Package Manager ready
- XCTest framework integrated
- Basic documentation with examples
- Clean code structure

### Capabilities
- ✅ Fast (no network)
- ✅ Lightweight (zero dependencies)
- ✅ Type-safe (Swift enums)
- ✅ Well-tested (10 tests)
- ✅ Error handling included
- ✅ Configurable rates

### Limitations (addressed in later versions)
- ⚠️ Only VND ↔ USD (AUD added in v0.3)
- ⚠️ Limited API design (improved in v0.3)
- ⚠️ No binary distribution (added in v0.2)
- ⚠️ No comprehensive docs (added in v0.6)

---

## Version Progression Summary

| Version | Focus | Tests | API |
|---------|-------|-------|-----|
| 0.0.1 | MVP Core | 10 | Simple |
| 0.0.2 | Binary Distribution | 10 | Fixed |
| 0.0.3 | AUD Support & Redesign | 14 | Enhanced |
| 0.0.4 | Complete AUD Paths | 17 | Stable |
| 0.0.5 | Release Automation | 17 | Stable |
| 0.0.6 | Documentation | 17 | Complete |

---

## Release Process

All releases from v0.0.5+ use:

```bash
./release.sh <version>
```

This automatically:
1. Updates version in source & tests
2. Runs test suite
3. Creates commit & tag
4. Pushes to GitHub

Then manually create GitHub Release with notes at:
```
https://github.com/RumVu/transferMoney_SDK/releases/new?tag=v<version>
```
