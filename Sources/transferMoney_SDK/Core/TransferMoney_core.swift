//
//  transferMoney_cor.swift
//  transferMoney_SDK
//
//  Created by Rum Vu on 16/4/26.
//

import Foundation

// MARK: - TransferMoney_core

/// Engine chuyển đổi tiền tệ trung tâm của **transferMoney SDK**.
///
/// Khởi tạo một instance rồi gọi ``convert(amount:from:to:)`` hoặc các hàm tiện lợi
/// ``vndToUsd(_:)`` / ``usdToVnd(_:)`` để thực hiện chuyển đổi.
///
/// ## Khởi tạo nhanh (dùng tỷ giá mặc định)
/// ```swift
/// let converter = TransferMoney_core()
/// ```
///
/// ## Khởi tạo với cấu hình tuỳ chỉnh
/// ```swift
/// let config = ConversionConfigs(VNDtoUSDRate: 25_100, decimalPrecision: 4)
/// let converter = TransferMoney_core(config: config)
/// ```
///
/// ## Cập nhật tỷ giá trước khi convert
/// ```swift
/// try converter.updateExchangeRates(25_800)
/// ```
///
/// ## Chuyển đổi tiền tệ
/// ```swift
/// // Dùng hàm đầy đủ — nhận ConversionResults
/// let result = try converter.convert(amount: 1_000_000, from: .VND, to: .USD)
/// print(result.targetAmount)          // 39.292...
/// print(result.FormattedTargetAmount) // "$39.29"
///
/// // Dùng shorthand — chỉ nhận số tiền
/// let usd = try converter.vndToUsd(500_000) // 19.646...
/// let vnd = try converter.usdToVnd(10)      // 254500.0
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
            sdkVersion: transferMoney_SDK.version,
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
