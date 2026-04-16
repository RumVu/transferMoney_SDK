//
//  Models.swift
//  transferMoney_SDK_v001
//
//  Created by Rum Vu on 16/4/26.
//

import Foundation

// MARK: - Currency

/// Các loại tiền tệ được hỗ trợ bởi **transferMoney SDK**.
///
/// Dùng enum này để chỉ định tiền tệ nguồn và đích khi gọi
/// ``TransferMoney_core/convert(amount:from:to:choose:)``.
///
/// ## Các cặp hỗ trợ (v0.0.3)
/// - VND ↔ USD
/// - VND → AUD *(qua USD trung gian)*
///
/// ## Ví dụ
/// ```swift
/// let converter = TransferMoney_core()
///
/// let result = try converter.convert(amount: 500_000, from: .VND, to: .AUD, choose: .standard)
///
/// print(Currency.AUD.displayName) // "Australian Dollar"
/// print(Currency.AUD.symbol)      // "A$"
///
/// for currency in Currency.allCases {
///     print(currency.rawValue) // "VND", "USD", "AUD"
/// }
/// ```
public enum Currency: String, CaseIterable, Sendable {

    /// Đồng Việt Nam (₫).
    case VND = "VND"

    /// Đô la Mỹ ($).
    case USD = "USD"

    /// Đô la Úc (A$).
    case AUD = "AUD"

    /// Tên đầy đủ của loại tiền tệ.
    ///
    /// - VND → `"VietNam Dong"`
    /// - USD → `"Dollar"`
    /// - AUD → `"Australian Dollar"`
    public var displayName: String {
        switch self {
        case .VND: return "VietNam Dong"
        case .USD: return "Dollar"
        case .AUD: return "Australian Dollar"
        }
    }

    /// Ký hiệu tiền tệ.
    ///
    /// - VND → `"đ"`
    /// - USD → `"$"`
    /// - AUD → `"A$"`
    public var symbol: String {
        switch self {
        case .VND: return "đ"
        case .USD: return "$"
        case .AUD: return "A$"
        }
    }
}
