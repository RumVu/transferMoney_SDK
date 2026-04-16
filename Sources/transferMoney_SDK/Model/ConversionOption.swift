//
//  ConversionOption.swift
//  transferMoney_SDK
//
//  Created by Rum Vu on 16/4/26.
//

// MARK: - ConversionOption

/// Tuỳ chọn tỷ giá khi thực hiện chuyển đổi tiền tệ.
///
/// Truyền vào tham số `choose` của ``TransferMoney_core/convert(amount:from:to:choose:)``.
///
/// ## Ví dụ
/// ```swift
/// let converter = TransferMoney_core()
///
/// // Dùng tỷ giá mặc định đã cấu hình trong SDK
/// let result = try converter.convert(amount: 1_000_000, from: .VND, to: .USD, choose: .standard)
///
/// // Dùng tỷ giá tuỳ chỉnh (ví dụ: lấy từ API của bạn)
/// let result2 = try converter.convert(amount: 1_000_000, from: .VND, to: .USD, choose: .customRate(25_800))
/// ```
public enum ConversionOption {

    /// Dùng tỷ giá mặc định đã được cấu hình trong ``TransferMoney_core/config``.
    case standard

    /// Dùng tỷ giá tuỳ chỉnh do bạn cung cấp.
    ///
    /// - Parameter rate: Tỷ giá VND/USD (số VND = 1 USD). Phải **> 0**.
    case customRate(_ rate: Double)
}
