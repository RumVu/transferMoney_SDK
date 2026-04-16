// The Swift Programming Language
// https://docs.swift.org/swift-book

/// Namespace chứa metadata của **transferMoney SDK**.
///
/// Không cần khởi tạo — tất cả các thuộc tính đều là `static`.
///
/// ## Ví dụ
/// ```swift
/// print(transferMoney_SDK.version)          // "0.0.1"
/// print(transferMoney_SDK.defaultVNDToUSDRate) // 25450.0
/// ```
public struct transferMoney_SDK {

    /// Phiên bản hiện tại của SDK.
    ///
    /// Dùng để kiểm tra phiên bản trong kết quả chuyển đổi (`ConversionResults.sdkVersion`)
    /// hoặc khi cần log / debug.
    public static let version = "0.0.1"

    /// Tỷ giá VND/USD mặc định: **1 USD = 25,450 VND**.
    ///
    /// Đây là tỷ giá tĩnh dùng cho v0.0.1.
    /// Trong môi trường production, nên thay thế bằng tỷ giá lấy từ nhà cung cấp thời gian thực
    /// thông qua ``TransferMoney_core/updateExchangeRates(_:)``.
    public static let defaultVNDToUSDRate: Double = 25_450.0

    private init() {}
}
