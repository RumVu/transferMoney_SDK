// The Swift Programming Language
// https://docs.swift.org/swift-book

/// Namespace chứa metadata của **transferMoney SDK**.
///
/// Không cần khởi tạo — tất cả các thuộc tính đều là `static`.
///
/// ## Ví dụ
/// ```swift
/// print(TransferMoneySDK.version)          // "0.0.1"
/// print(TransferMoneySDK.defaultVNDToUSDRate) // 25450.0
/// ```
public struct TransferMoneySDK {

    /// Phiên bản hiện tại của SDK.
    ///
    /// Dùng để kiểm tra phiên bản trong kết quả chuyển đổi (`ConversionResults.sdkVersion`)
    /// hoặc khi cần log / debug.
    public static let version = "0.0.8"

    /// Tỷ giá VND/USD mặc định: **1 USD = 25,450 VND**.
    public static let defaultVNDToUSDRate: Double = 25_450.0

    /// Tỷ giá AUD/USD mặc định: **1 AUD = 0.63 USD**.
    public static let defaultAUDToUSDRate: Double = 0.63

    private init() {}
}
