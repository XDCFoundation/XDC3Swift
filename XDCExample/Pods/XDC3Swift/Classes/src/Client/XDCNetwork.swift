//
//  XDCNetwork.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation

public enum XDCNetwork: Equatable {
    case Mainnet
    case Apothem
    case Custom(String)
    
    static func fromString(_ networkId: String) -> XDCNetwork {
        switch networkId {
        case "50":
            return .Mainnet
        case "51":
            return .Apothem
        default:
            return .Custom(networkId)
        }
    }
    
    var stringValue: String {
        switch self {
        case .Mainnet:
            return "50"
        case .Apothem:
            return "51"
        case .Custom(let str):
            return str
        }
    }
    
    var intValue: Int {
        switch self {
        case .Mainnet:
            return 50
        case .Apothem:
            return 51
        case .Custom(let str):
            return Int(str) ?? 0
        }
    }
}

public func ==(lhs: XDCNetwork, rhs: XDCNetwork) -> Bool {
    return lhs.stringValue == rhs.stringValue
    
}
