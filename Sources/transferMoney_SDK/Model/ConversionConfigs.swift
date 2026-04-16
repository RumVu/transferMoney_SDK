//
//  ConversionConfigs.swift
//  TransferMoneySDK
//
//  Created by Rum Vu on 16/4/26.
//
// MARK: - ConversionConfigs
import Foundation

/// Cấu hình cho bộ chuyển đổi tiền tệ ``TransferMoney_core``.
///
/// Truyền struct này vào ``TransferMoney_core/init(config:)`` để tuỳ chỉnh
/// tỷ giá và độ chính xác thập phân ngay từ lúc khởi tạo.
/// Sau đó có thể cập nhật tỷ giá tại runtime bằng ``TransferMoney_core/updateExchangeRates(_:)``.
///
/// ## Dùng giá trị mặc định
/// ```swift
/// let converter = TransferMoney_core()
/// // Tỷ giá: 25450, độ chính xác: 6 chữ số thập phân
/// ```
///
/// ## Tuỳ chỉnh cấu hình
/// ```swift
/// let config = ConversionConfigs(VNDtoUSDRate: 25_800, decimalPrecision: 2)
/// let converter = TransferMoney_core(config: config)
/// ```
public struct ConversionConfigs {

    /// Tỷ giá VND/USD: số VND tương đương với 1 USD.
    ///
    /// Mặc định: `25_450.0` (lấy từ ``TransferMoneySDK/defaultVNDToUSDRate``).
    /// Có thể thay đổi sau khi khởi tạo bằng ``TransferMoney_core/updateExchangeRates(_:)``.
    public var VNDtoUSDRate: Double

    /// Số chữ số thập phân dùng để làm tròn kết quả chuyển đổi.
    ///
    /// Mặc định: `6`. Giảm giá trị này nếu bạn muốn kết quả ít chữ số hơn (VD: `2` cho hiển thị UI).
    public var decimalPrecision: Int

    /// Tạo cấu hình với tỷ giá và độ chính xác tuỳ chọn.
    ///
    /// - Parameters:
    ///   - VNDtoUSDRate: Tỷ giá VND/USD. Mặc định: `25_450.0`.
    ///   - decimalPrecision: Số chữ số thập phân để làm tròn. Mặc định: `6`.
    public init(
        VNDtoUSDRate: Double = TransferMoneySDK.defaultVNDToUSDRate,
        decimalPrecision: Int = 6
    ) {
        self.VNDtoUSDRate = VNDtoUSDRate
        self.decimalPrecision = decimalPrecision
    }
}

