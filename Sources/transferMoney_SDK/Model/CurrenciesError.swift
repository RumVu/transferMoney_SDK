//
//  CurrenciesError.swift
//  transferMoney_SDK
//
//  Created by Rum Vu on 16/4/26.
//

// MARK: - CurrenciesError

import Foundation

/// Các lỗi có thể xảy ra khi dùng **transferMoney SDK**.
///
/// Tất cả các hàm throwing trong ``TransferMoney_core`` đều ném ra kiểu lỗi này.
/// Dùng `do-catch` để bắt và xử lý từng trường hợp.
///
/// ## Ví dụ bắt lỗi
/// ```swift
/// let converter = TransferMoney_core()
///
/// do {
///     let result = try converter.convert(amount: -100, from: .VND, to: .USD)
/// } catch CurrenciesError.invalidAmount(let msg) {
///     print("Số tiền không hợp lệ:", msg)
/// } catch CurrenciesError.unsupportedConversion(let from, let to) {
///     print("Không hỗ trợ đổi từ \(from.rawValue) sang \(to.rawValue)")
/// } catch CurrenciesError.invalidExchangeRates(let rate) {
///     print("Tỷ giá không hợp lệ:", rate)
/// } catch {
///     print("Lỗi khác:", error)
/// }
/// ```
public enum CurrenciesError: Error, LocalizedError {

    /// Số tiền không hợp lệ (thường là số âm).
    ///
    /// - Parameter message: Mô tả chi tiết, ví dụ: `"Amount must be >= 0, got -100"`.
    case invalidAmount(String)

    /// Cặp tiền tệ chưa được hỗ trợ trong phiên bản SDK hiện tại.
    ///
    /// - Parameters:
    ///   - from: Tiền tệ nguồn.
    ///   - to: Tiền tệ đích.
    case unsupportedConversion(from: Currency, to: Currency)

    /// Tỷ giá không hợp lệ (phải > 0).
    ///
    /// - Parameter rate: Giá trị tỷ giá bị từ chối, ví dụ: `0` hoặc `-1.5`.
    case invalidExchangeRates(Double)

    /// Mô tả lỗi dạng chuỗi (dùng cho logging hoặc hiển thị UI).
    public var errorDescription: String? {
        switch self {
        case .invalidAmount(let msg):
            return "Invalid amount: \(msg)"
        case .unsupportedConversion(let from, let to):
            return "Conversion from \(from.rawValue) to \(to.rawValue) is not supported in this SDK version"
        case .invalidExchangeRates(let rate):
            return "Invalid exchange rate: \(rate)"
        }
    }
}

