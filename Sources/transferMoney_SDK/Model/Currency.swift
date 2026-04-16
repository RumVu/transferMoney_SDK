//
//  Models.swift
//  transferMoney_SDK_v001
//
//  Created by Rum Vu on 16/4/26.
//

import Foundation

// MARK: - Currency

/// Các loại tiền tệ được hỗ trợ bởi **transferMoney SDK** (v0.0.1).
///
/// Dùng enum này để chỉ định tiền tệ nguồn và đích khi gọi
/// ``TransferMoney_core/convert(amount:from:to:)``.
///
/// ## Ví dụ
/// ```swift
/// let converter = TransferMoney_core()
///
/// // Dùng trong convert
/// let result = try converter.convert(amount: 500_000, from: .VND, to: .USD)
///
/// // Truy cập metadata
/// print(Currency.VND.displayName) // "VietNam Dong"
/// print(Currency.USD.symbol)      // "$"
///
/// // Liệt kê tất cả tiền tệ hỗ trợ
/// for currency in Currency.allCases {
///     print(currency.rawValue) // "VND", "USD"
/// }
/// ```
public enum Currency: String, CaseIterable, Sendable {

    /// Đồng Việt Nam (₫).
    case VND = "VND"

    /// Đô la Mỹ ($).
    case USD = "USD"

    /// Tên đầy đủ của loại tiền tệ.
    ///
    /// - VND → `"VietNam Dong"`
    /// - USD → `"Dollar"`
    public var displayName: String {
        switch self {
        case .VND: return "VietNam Dong"
        case .USD: return "Dollar"
        }
    }

    /// Ký hiệu tiền tệ.
    ///
    /// - VND → `"đ"`
    /// - USD → `"$"`
    public var symbol: String {
        switch self {
        case .VND: return "đ"
        case .USD: return "$"
        }
    }
}
