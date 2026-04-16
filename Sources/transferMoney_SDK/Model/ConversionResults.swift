//
//  ConversionResults.swift
//  transferMoney_SDK
//
//  Created by Rum Vu on 16/4/26.
//
import Foundation

// MARK: - ConversionResults

/// Kết quả đầy đủ trả về từ một lần chuyển đổi tiền tệ.
///
/// Struct này được trả về bởi ``TransferMoney_core/convert(amount:from:to:)``.
/// Nó chứa toàn bộ thông tin của phép đổi: số tiền, tỷ giá đã dùng,
/// timestamp và phiên bản SDK — hữu ích cho việc hiển thị UI, audit log, hoặc debug.
///
/// ## Ví dụ
/// ```swift
/// let converter = TransferMoney_core()
/// let result = try converter.convert(amount: 2_000_000, from: .VND, to: .USD)
///
/// print(result.sourceAmount)           // 2000000.0
/// print(result.targetAmount)           // 78.585...
/// print(result.exchangeRate)           // 25450.0
/// print(result.FormattedTargetAmount)  // "$ 78.5852"
/// print(result.FormattedSourceAmount) // "đ 2000000.00"
/// print(result.sdkVersion)             // "0.0.1"
/// print(result.timeStamp)              // 2026-04-16 ...
/// ```
public struct ConversionResults {

    /// Số tiền gốc trước khi chuyển đổi.
    public let sourceAmount: Double

    /// Loại tiền tệ nguồn (ví dụ: `.VND`).
    public let sourceCurrency: Currency

    /// Số tiền sau khi đã chuyển đổi.
    public let targetAmount: Double

    /// Loại tiền tệ đích (ví dụ: `.USD`).
    public let targetCurrency: Currency

    /// Tỷ giá hối đoái được dùng trong phép tính này.
    ///
    /// - VND → USD hoặc USD → VND: giá trị VND/USD tại thời điểm convert.
    /// - Cùng loại tiền: luôn là `1.0`.
    public let exchangeRate: Double

    /// Phiên bản SDK đã thực hiện phép chuyển đổi này.
    ///
    /// Dùng để tracking khi tích hợp nhiều phiên bản SDK song song.
    public let sdkVersion: String

    /// Mốc thời gian (UTC) thực hiện phép chuyển đổi.
    public let timeStamp: Date

    /// Số tiền đích đã được định dạng kèm ký hiệu tiền tệ.
    ///
    /// Ví dụ: `"$ 78.5852"` hoặc `"đ 2000000.00"`.
    ///
    /// - Note: Fallback về `"<symbol> <amount>"` nếu `NumberFormatter` không hỗ trợ ký hiệu đó.
    public var FormattedTargetAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = targetCurrency.symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 8
        return formatter.string(from: NSNumber(value: targetAmount))
            ?? "\(targetCurrency.symbol) \(String(format: "%.4f", targetAmount))"
    }

    /// Số tiền nguồn đã được định dạng kèm ký hiệu tiền tệ.
    ///
    /// Ví dụ: `"đ 2000000.00"` hoặc `"$ 50.00"`.
    ///
    /// - Note: Fallback về `"<symbol> <amount>"` nếu `NumberFormatter` không hỗ trợ ký hiệu đó.
    public var FormattedSourceAmount: String {
        let formatter_before = NumberFormatter()
        formatter_before.numberStyle = .currency
        formatter_before.currencyCode = sourceCurrency.symbol
        formatter_before.minimumFractionDigits = 2
        formatter_before.maximumFractionDigits = 8
        return formatter_before.string(from: NSNumber(value: sourceAmount))
            ?? "\(sourceCurrency.symbol) \(String(format: "%.2f", sourceAmount))"
    }
}
