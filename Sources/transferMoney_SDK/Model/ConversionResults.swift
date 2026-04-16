//
//  ConversionResults.swift
//  transferMoney_SDK
//
//  Created by Rum Vu on 16/4/26.
//
import Foundation

// MARK: ConversionResults
// Kết quả trả về từ một hoạt động chuyển đổi tiền tệ.
public struct ConversionResults {
    //Số tiền gốc được đem đi chuyển đổi (nguồn).
    public let sourceAmount: Double
    //Loại tiền tệ nguồn
    public let sourceCurrency: Currency
    //Số tiền sau khi đã chuyển đổi
    public let targetAmount: Double
    //Loại tiền tệ sau đổi
    public let targetCurrency: Currency
    //Tỷ giá hối đoái được sử dụng
    public let exChangeRate: Double
    //Phiên bản SDK đã thực hiện phép chuyển đổi này
    public let sdkVersion: String
    //mốc thời gian (ngày, giờ) thực hiện phép chuyển đổi.
    public let timeStamp: Date
    //định dạng của số tiền sau chuyển đổi
    public var FormattedTargetAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = targetCurrency.symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 8
        return formatter.string(from: NSNumber(value: targetAmount))
        ?? "\(targetCurrency.symbol) \(String(format: "%.4f",targetAmount))"
    }
    //định dạng của số tiền nguồn chuyển đổi
    public var FormatteerSourceAmount: String {
        let formatter_before = NumberFormatter()
        formatter_before.numberStyle = .currency
        formatter_before.currencyCode = sourceCurrency.symbol
        formatter_before.minimumFractionDigits = 2
        formatter_before.maximumFractionDigits = 8
        return formatter_before.string(from: NSNumber(value: sourceAmount))
        ?? "\(sourceCurrency.symbol) \(String(format: "%.2f",sourceAmount))"
    }
}
