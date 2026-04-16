// The Swift Programming Language
// https://docs.swift.org/swift-book

public struct transferMoney_SDK {
    
    /// Current SDK version
    public static let version = "0.0.1"
    
    /// Default exchange rate: 1 USD = 25,450 VND (static rate for v0.0.1)
    /// In production, this should be fetched from a live rate provider.
    public static let defaultVNDToUSDRate: Double = 25_450.0
    
    private init() {}
}
