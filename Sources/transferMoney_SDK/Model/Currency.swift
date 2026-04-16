//
//  Models.swift
//  transferMoney_SDK_v001
//
//  Created by Rum Vu on 16/4/26.
//

import Foundation

//MARK: -- Suport Currencies

//--currencies support

public enum Currency: String, CaseIterable, Sendable { // sử dụng CaseIterable để tự động tạo ra 1 danh sách chứa các case có trong enum đó. nó được ví như 1 Protocol chuyên dùng cho enum
    case VND = "VND"
    case USD = "USD"
    
    public var displayName:String{
        switch self{
        case .VND: return "VietNam Dong"
        case .USD: return "Dollar"
        }
    }
    
    public var symbol:String{
        switch self{
        case .VND: return "đ"
        case .USD: return "$"
        }
    }
}
