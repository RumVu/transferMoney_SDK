//
//  transferMoney_cor.swift
//  transferMoney_SDK
//
//  Created by Rum Vu on 16/4/26.
//

import Foundation

//MARK: Properties
public final class TransferMoney_core {
    //current conversion
    public private(set) var config:ConversionConfigs
    
    //MARK: - init
    public init(){
        self.config = ConversionConfigs()
    }
    
    /// Parameteer config: `ConversionConfig`
    public init(config: ConversionConfigs){
        self.config = config
    }
    
    //MARK: -Configuration
    
    public func updateExchangeRates(_ rate: Double) throws {
        guard rate > 0 else {
            throw CurrenciesError.invalidExchangeRates(rate)
        }
        config.VNDtoUSDRate = rate
    }
    
    //MARK: - Core Conversion API
    /// Convert an amount between supported currencies.
    ///
    /// Supported pairs in v0.0.1:
    /// - `.vnd` → `.usd`
    /// - `.usd` → `.vnd`
    ///
    /// - Parameters:
    ///   - amount: The source amount (must be ≥ 0)
    ///   - from: Source `Currency`
    ///   - to: Target `Currency`
    /// - Returns: A `ConversionResult` with full details
    /// - Throws: `VNCurrencyError` on invalid input or unsupported pair
    @discardableResult
    public func convert(
        amount: Double,
        from sourcCurrency: Currency,
    to targetCurrency: Currency) throws -> ConversionResults
    {
        guard amount >= 0 else {
            throw CurrenciesError.invaldAmount("Amount must b =>0, got \(amount)")
        }
        let convertedAmount: Double
        let rateUsed: Double
        switch (sourcCurrency, targetCurrency) {

        case (.VND, .USD):
            convertedAmount = round(
                (amount / config.VNDtoUSDRate) * pow(10, Double(config.decimalPrecision))
            ) / pow(10, Double(config.decimalPrecision))
            rateUsed = config.VNDtoUSDRate  // ← sửa từ 1.0

        case (.USD, .VND):
            // nhân ngược lại
            convertedAmount = round(amount * config.VNDtoUSDRate)
            rateUsed = config.VNDtoUSDRate  // ← thêm case mới này

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
            exChangeRate: rateUsed,
            sdkVersion: transferMoney_SDK.version,
            timeStamp: Date()
        )
    }
    
    //MARK: -Convenience Methods
    /// Convert VND to USD (shorthand)
    /// - Parameter vnd: Amount in Vietnamese Dong
    /// - Returns: Equivalent amount in US Dollars
    
    public func vndToUsd(_ vnd: Double) throws -> Double {
        let result = try convert(amount: vnd, from: .VND, to: .USD)
        return result.targetAmount
    }
    
    public func usdToVnd(_ usd: Double) throws -> Double {
        let result = try convert(amount: usd, from: .USD, to: .VND)
        return result.targetAmount
    }
    
}
