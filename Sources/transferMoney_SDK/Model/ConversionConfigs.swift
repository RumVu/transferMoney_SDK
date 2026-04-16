//
//  ConversionConfigs.swift
//  transferMoney_SDK
//
//  Created by Rum Vu on 16/4/26.
//
// MARK: - Conversion Config
import Foundation
//Cấu hình cho bộ chuyển đổi tiền tệ.
public struct ConversionConfigs {
    //lấy giá trị từ biến defaultVNDToUSDRate trong SDK
    public var VNDtoUSDRate:Double
    //Số lượng chữ số thập phân để làm tròn kết quả
    public var decimalPrecision:Int
    
    public init(
        VNDtoUSDRate: Double = transferMoney_SDK.defaultVNDToUSDRate,
        decimalPrecision: Int = 6
    ){
        self.VNDtoUSDRate = VNDtoUSDRate
        self.decimalPrecision = decimalPrecision
    }
}

