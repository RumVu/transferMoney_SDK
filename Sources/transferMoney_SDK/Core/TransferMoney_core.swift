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
/// // 2. Đổi tiền — shorthand (chỉ lấy số tiền)
/// let usd = try converter.vndToUsd(1_000_000) // → 39.292...
/// let vnd = try converter.usdToVnd(10)         // → 254500.0
///
/// // 3. Đổi tiền — đầy đủ (lấy kèm tỷ giá, timestamp, version SDK...)
/// let result = try converter.convert(amount: 1_000_000, from: .VND, to: .USD)
/// print(result.targetAmount)          // 39.292...
/// print(result.exchangeRate)          // 25450.0
/// print(result.FormattedTargetAmount) // "$ 39.2927"
/// print(result.timeStamp)             // 2026-04-16 ...
/// ```
///
/// ## Muốn dùng tỷ giá riêng?
///
/// ```swift
/// // Cách 1 — set khi khởi tạo
/// let converter = TransferMoney_core(config: ConversionConfigs(VNDtoUSDRate: 25_800))
///
/// // Cách 2 — cập nhật lúc runtime (ví dụ sau khi fetch từ server)
/// try converter.updateExchangeRates(25_900)
/// ```
///
/// ## Xử lý lỗi
///
/// ```swift
/// do {
///     let usd = try converter.vndToUsd(-100)
/// } catch CurrenciesError.invalidAmount(let msg) {
///     print(msg) // "Amount must be >= 0, got -100"
/// } catch CurrenciesError.invalidExchangeRates(let rate) {
///     print("Tỷ giá không hợp lệ: \(rate)")
/// } catch CurrenciesError.unsupportedConversion(let from, let to) {
///     print("Chưa hỗ trợ \(from.rawValue) → \(to.rawValue)")
/// }
/// ```
///
/// - Note: Class này là `final` — không thể kế thừa.
public final class TransferMoney_core {

    // MARK: Properties

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
    /// Gọi hàm này khi bạn nhận được tỷ giá mới từ server trước mỗi lần convert.
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
    /// Các cặp tiền tệ hỗ trợ trong v0.0.1:
    /// - ``Currency/VND`` → ``Currency/USD``
    /// - ``Currency/USD`` → ``Currency/VND``
    /// - Cùng loại tiền (VD: VND → VND): trả về nguyên số tiền gốc.
    ///
    /// - Parameters:
    ///   - amount: Số tiền cần chuyển đổi. Phải **≥ 0**.
    ///   - sourcCurrency: Loại tiền tệ nguồn (``Currency``).
    ///   - targetCurrency: Loại tiền tệ đích (``Currency``).
    /// - Returns: ``ConversionResults`` chứa đầy đủ thông tin: số tiền đổi được,
    ///   tỷ giá đã dùng, timestamp, version SDK.
    /// - Throws:
    ///   - ``CurrenciesError/invalidAmount(_:)`` nếu `amount < 0`.
    ///   - ``CurrenciesError/unsupportedConversion(from:to:)`` nếu cặp tiền tệ chưa hỗ trợ.
    ///
    /// ## Ví dụ
    /// ```swift
    /// let converter = TransferMoney_core()
    ///
    /// // VND → USD
    /// let result = try converter.convert(amount: 2_000_000, from: .VND, to: .USD)
    /// print(result.targetAmount)          // 78.585...
    /// print(result.FormattedTargetAmount) // "$ 78.5852"
    ///
    /// // USD → VND
    /// let result2 = try converter.convert(amount: 50, from: .USD, to: .VND)
    /// print(result2.targetAmount) // 1272500.0
    /// ```
    @discardableResult
    public func convert(
        amount: Double,
        from sourcCurrency: Currency,
        to targetCurrency: Currency
    ) throws -> ConversionResults {
        guard amount >= 0 else {
            throw CurrenciesError.invalidAmount("Amount must be >= 0, got \(amount)")
        }
        let convertedAmount: Double
        let rateUsed: Double
        switch (sourcCurrency, targetCurrency) {

        case (.VND, .USD):
            convertedAmount = round(
                (amount / config.VNDtoUSDRate) * pow(10, Double(config.decimalPrecision))
            ) / pow(10, Double(config.decimalPrecision))
            rateUsed = config.VNDtoUSDRate

        case (.USD, .VND):
            convertedAmount = round(amount * config.VNDtoUSDRate)
            rateUsed = config.VNDtoUSDRate

        case let (src, dst) where src == dst:
            convertedAmount = amount
            rateUsed = 1.0

        default:
            throw CurrenciesError.unsupportedConversion(from: sourcCurrency, to: targetCurrency)
        }
        return ConversionResults(
            sourceAmount: amount,
            sourceCurrency: sourcCurrency,
            targetAmount: convertedAmount,
            targetCurrency: targetCurrency,
            exchangeRate: rateUsed,
            sdkVersion: TransferMoneySDK.version,
            timeStamp: Date()
        )
    }

    // MARK: - Convenience Methods

    /// Chuyển đổi VND sang USD (shorthand).
    ///
    /// Tương đương với gọi ``convert(amount:from:to:)`` với `from: .VND, to: .USD`
    /// và lấy `targetAmount` từ kết quả.
    ///
    /// - Parameter vnd: Số tiền VND cần đổi. Phải **≥ 0**.
    /// - Returns: Số tiền USD tương đương (kiểu `Double`).
    /// - Throws: ``CurrenciesError/invalidAmount(_:)`` nếu `vnd < 0`.
    ///
    /// ## Ví dụ
    /// ```swift
    /// let usd = try converter.vndToUsd(1_000_000) // ≈ 39.29
    /// ```
    public func vndToUsd(_ vnd: Double) throws -> Double {
        let result = try convert(amount: vnd, from: .VND, to: .USD)
        return result.targetAmount
    }

    /// Chuyển đổi USD sang VND (shorthand).
    ///
    /// Tương đương với gọi ``convert(amount:from:to:)`` với `from: .USD, to: .VND`
    /// và lấy `targetAmount` từ kết quả.
    ///
    /// - Parameter usd: Số tiền USD cần đổi. Phải **≥ 0**.
    /// - Returns: Số tiền VND tương đương (kiểu `Double`).
    /// - Throws: ``CurrenciesError/invalidAmount(_:)`` nếu `usd < 0`.
    ///
    /// ## Ví dụ
    /// ```swift
    /// let vnd = try converter.usdToVnd(10) // 254500.0
    /// ```
    public func usdToVnd(_ usd: Double) throws -> Double {
        let result = try convert(amount: usd, from: .USD, to: .VND)
        return result.targetAmount
    }
}
