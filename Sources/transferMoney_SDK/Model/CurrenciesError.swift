//
//  CurrenciesError.swift
//  transferMoney_SDK
//
//  Created by Rum Vu on 16/4/26.
//

//MARK: SDK Errors

import Foundation
public enum CurrenciesError: Error,LocalizedError {
    case invaldAmount(String)
    case unsupportedConversion(from: Currency, to: Currency)
    case invalidExchangeRates(Double)
    
    public var errorDescription: String? {
        switch self {
        case .invaldAmount(let msg):
            return "Invalid amount: \(msg)"
        case .unsupportedConversion(let from,let to):
            return "Conversion from \(from.rawValue) to \(to.rawValue) is not supported in this SDK version"
        case .invalidExchangeRates(let rate):
            return "Invalid exchange rate: \(rate)"
        }
    }
}

