//
//  transferMoney_cor.swift
//  transferMoney_SDK
//
//  Created by Rum Vu on 16/4/26.
//

import Foundation

// MARK: - TransferMoney_core

/// **Đây là class duy nhất bạn cần dùng** để thực hiện chuyển đổi tiền tệ VND ↔ USD.
///
/// ## Quick Start
///
/// ```swift
/// // 1. Khởi tạo
/// let converter = TransferMoney_core()
///
/// // 2. Đổi tiền với tỷ giá mặc định
/// let result = try converter.convert(amount: 1_000_000, from: .VND, to: .USD, choose: .standard)
/// print(result.targetAmount)          // 39.292...
/// print(result.FormattedTargetAmount) // "$ 39.2927"
///
/// // 3. Đổi tiền với tỷ giá tuỳ chỉnh
/// let result2 = try converter.convert(amount: 1_000_000, from: .VND, to: .USD, choose: .customRate(25_800))
///
/// // 4. Shorthand — chỉ lấy số tiền
/// let usd = try converter.vndToUsd(1_000_000) // → 39.292...
/// let vnd = try converter.usdToVnd(10)         // → 254500.0
/// ```
///
/// ## Xử lý lỗi
///
/// ```swift
/// do {
///     let result = try converter.convert(amount: -100, from: .VND, to: .USD, choose: .standard)
/// } catch CurrenciesError.invalidAmount(let msg) {
///     print(msg)
/// } catch CurrenciesError.invalidExchangeRates(let rate) {
///     print("Tỷ giá không hợp lệ: \(rate)")
/// } catch CurrenciesError.unsupportedConversion(let from, let to) {
///     print("Chưa hỗ trợ \(from.rawValue) → \(to.rawValue)")
/// }
/// ```
///
/// - Note: Class này là `final` — không thể kế thừa.
public final class TransferMoney_core {

    // MARK: - Properties

    /// Cấu hình hiện tại của converter (chỉ đọc từ bên ngoài).
    ///
    /// Để thay đổi tỷ giá, dùng ``updateExchangeRates(_:)`` thay vì gán trực tiếp.
    public private(set) var config: ConversionConfigs

    // MARK: - Khởi tạo

    /// Tạo converter với cấu hình mặc định.
    ///
    /// Tỷ giá mặc định: **1 USD = 25,450 VND**, độ chính xác thập phân: **6 chữ số**.
    public init() {
        self.config = ConversionConfigs()
    }

    /// Tạo converter với cấu hình tuỳ chỉnh.
    ///
    /// - Parameter config: ``ConversionConfigs`` chứa tỷ giá và độ chính xác mong muốn.
    ///
    /// ## Ví dụ
    /// ```swift
    /// let config = ConversionConfigs(VNDtoUSDRate: 25_100, decimalPrecision: 2)
    /// let converter = TransferMoney_core(config: config)
    /// ```
    public init(config: ConversionConfigs) {
        self.config = config
    }

    // MARK: - Cấu hình

    /// Cập nhật tỷ giá VND/USD tại thời điểm chạy.
    ///
    /// - Parameter rate: Tỷ giá mới (số VND tương đương 1 USD). Phải **> 0**.
    /// - Throws: ``CurrenciesError/invalidExchangeRates(_:)`` nếu `rate ≤ 0`.
    ///
    /// ## Ví dụ
    /// ```swift
    /// try converter.updateExchangeRates(25_800)
    /// ```
    public func updateExchangeRates(_ rate: Double) throws {
        guard rate > 0 else {
            throw CurrenciesError.invalidExchangeRates(rate)
        }
        config.VNDtoUSDRate = rate
    }

    // MARK: - Core Conversion API

    /// Chuyển đổi một số tiền giữa hai loại tiền tệ được hỗ trợ.
    ///
    /// - Parameters:
    ///   - amount: Số tiền cần chuyển đổi. Phải **≥ 0**.
    ///   - from: Loại tiền tệ nguồn (``Currency``).
    ///   - to: Loại tiền tệ đích (``Currency``).
    ///   - choose: Tuỳ chọn tỷ giá (``ConversionOption``).
    ///     - `.standard` — dùng tỷ giá đã cấu hình sẵn.
    ///     - `.customRate(Double)` — dùng tỷ giá bạn tự cung cấp.
    /// - Returns: ``ConversionResults`` chứa đầy đủ thông tin chuyển đổi.
    /// - Throws: ``CurrenciesError`` nếu input không hợp lệ.
    ///
    /// ## Ví dụ
    /// ```swift
    /// let converter = TransferMoney_core()
    ///
    /// let result = try converter.convert(amount: 2_000_000, from: .VND, to: .USD, choose: .standard)
    /// let result2 = try converter.convert(amount: 2_000_000, from: .VND, to: .USD, choose: .customRate(25_800))
    /// ```
    @discardableResult
    public func convert(
        amount: Double,
        from: Currency,
        to: Currency,
        choose: ConversionOption
    ) throws -> ConversionResults {
        try _validate(amount: amount)
        let rate = try _resolveRate(from: choose)
        let (convertedAmount, rateUsed) = try _calculate(amount: amount, from: from, to: to, rate: rate)
        return _buildResult(amount: amount, from: from, to: to, converted: convertedAmount, rate: rateUsed)
    }

    // MARK: - Convenience Methods

    /// Chuyển đổi VND sang USD (shorthand).
    ///
    /// - Parameter vnd: Số tiền VND cần đổi. Phải **≥ 0**.
    /// - Returns: Số tiền USD tương đương.
    /// - Throws: ``CurrenciesError/invalidAmount(_:)`` nếu `vnd < 0`.
    ///
    /// ## Ví dụ
    /// ```swift
    /// let usd = try converter.vndToUsd(1_000_000) // ≈ 39.29
    /// ```
    public func vndToUsd(_ vnd: Double) throws -> Double {
        try convert(amount: vnd, from: .VND, to: .USD, choose: .standard).targetAmount
    }

    /// Chuyển đổi USD sang VND (shorthand).
    ///
    /// - Parameter usd: Số tiền USD cần đổi. Phải **≥ 0**.
    /// - Returns: Số tiền VND tương đương.
    /// - Throws: ``CurrenciesError/invalidAmount(_:)`` nếu `usd < 0`.
    ///
    /// ## Ví dụ
    /// ```swift
    /// let vnd = try converter.usdToVnd(10) // 254500.0
    /// ```
    public func usdToVnd(_ usd: Double) throws -> Double {
        try convert(amount: usd, from: .USD, to: .VND, choose: .standard).targetAmount
    }
}

// MARK: - Private Processing

private extension TransferMoney_core {

    func _validate(amount: Double) throws {
        guard amount >= 0 else {
            throw CurrenciesError.invalidAmount("Amount must be >= 0, got \(amount)")
        }
    }

    func _resolveRate(from option: ConversionOption) throws -> Double {
        switch option {
        case .standard:
            return config.VNDtoUSDRate
        case .customRate(let rate):
            guard rate > 0 else {
                throw CurrenciesError.invalidExchangeRates(rate)
            }
            return rate
        }
    }

    func _calculate(
        amount: Double,
        from: Currency,
        to: Currency,
        rate: Double
    ) throws -> (converted: Double, rate: Double) {
        switch (from, to) {
        case (.VND, .USD):
            let result = round(
                (amount / rate) * pow(10, Double(config.decimalPrecision))
            ) / pow(10, Double(config.decimalPrecision))
            return (result, rate)
        case (.USD, .VND):
            return (round(amount * rate), rate)
        case let (src, dst) where src == dst:
            return (amount, 1.0)
        default:
            throw CurrenciesError.unsupportedConversion(from: from, to: to)
        }
    }

    func _buildResult(
        amount: Double,
        from: Currency,
        to: Currency,
        converted: Double,
        rate: Double
    ) -> ConversionResults {
        ConversionResults(
            sourceAmount: amount,
            sourceCurrency: from,
            targetAmount: converted,
            targetCurrency: to,
            exchangeRate: rate,
            sdkVersion: TransferMoneySDK.version,
            timeStamp: Date()
        )
    }
}
