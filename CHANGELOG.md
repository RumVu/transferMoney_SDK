# Changelog

All notable changes to this project will be documented in this file.

## [0.0.4] - 2026-04-16

### Added
- USD ↔ AUD bidirectional conversion support
- AUD → VND conversion path through USD intermediary
- Complete multi-currency conversion matrix (6 supported paths)
- 3 new conversion tests for AUD paths

### Changed
- Updated documentation with AUD conversion examples
- Extended class docstring to cover all supported currency pairs

### Tests
- Total: 17 tests all passing

## [0.0.3] - 2026-04-16

### Added
- Australian Dollar (AUD) currency support
- VND → AUD conversion through USD intermediary
- `ConversionOption` enum for rate selection (`.standard` or `.customRate`)
- `AUDtoUSDRate` property to `ConversionConfigs` (default: 0.63)
- Shorthand convenience methods: `vndToUsd()` and `usdToVnd()`

### Changed
- Refactored `TransferMoney_core` with private extension methods
- Updated `convert()` method to accept `ConversionOption` parameter
- Improved code organization and encapsulation

### Fixed
- Module name collision: renamed struct from `transferMoney_SDK` to `TransferMoneySDK`
- Fixed typo in `ConversionResults`: `exChangeRate` → `exchangeRate`
- Fixed typo in `ConversionResults`: `FormatteerSourceAmount` → `FormattedSourceAmount`
- Fixed typo in `CurrenciesError`: `invaldAmount` → `invalidAmount`

### Tests
- Total: 14 tests all passing
- Added VND → AUD conversion tests
- Added custom rate validation tests

## [0.0.2] - 2026-04-16

### Added
- XCFramework binary distribution support
- Swift Package Manager improvements
- Enhanced documentation with code examples
- GitHub Pages for DocC documentation

### Changed
- Updated Swift tools version to 6.0
- Added `type: .dynamic` to Package.swift for binary framework
- Enabled `BUILD_LIBRARY_FOR_DISTRIBUTION` build flag

### Added Scripts
- `build_xcframework.sh` for automated XCFramework building

### Documentation
- Deployed automated DocC generation via GitHub Actions
- Added `.github/workflows/deploy-docs.yml` for CI/CD

## [0.0.1] - 2026-04-16

### Initial Release
- Core currency conversion functionality
- VND ↔ USD bidirectional support
- `TransferMoney_core` class with main API
- `ConversionConfigs` for customization
- `Currency` enum (VND, USD)
- `ConversionResults` for result structure
- `CurrenciesError` for error handling
- Basic test suite (10 tests)
- XCTest framework integration

### Features
- Configurable exchange rates
- Decimal precision control
- Timestamp tracking
- SDK version in results

---

## Version Format

This project follows [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking API changes
- **MINOR**: New features (backwards compatible)
- **PATCH**: Bug fixes (backwards compatible)

## Release Process

```bash
./release.sh 0.0.5
```

This automatically:
1. Updates version numbers
2. Runs tests
3. Creates commit and tag
4. Pushes to GitHub

Don't forget to create the GitHub Release manually with release notes!
