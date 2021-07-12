//
//  XinfinNetwork.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation

public enum XinfinNetwork: Equatable {
    case Mainnet
    case Ropsten
    case Rinkeby
    case Kovan
    case Apothem
    case Custom(String)
    
    static func fromString(_ networkId: String) -> XinfinNetwork {
        switch networkId {
        case "1":
            return .Mainnet
        case "3":
            return .Ropsten
        case "4":
            return .Rinkeby
        case "42":
            return .Kovan
        case "51":
            return .Apothem
        default:
            return .Custom(networkId)
        }
    }
    
    var stringValue: String {
        switch self {
        case .Mainnet:
            return "1"
        case .Ropsten:
            return "3"
        case .Rinkeby:
            return "4"
        case .Kovan:
            return "42"
        case .Apothem:
            return "51"
        case .Custom(let str):
            return str
        }
    }
    
    var intValue: Int {
        switch self {
        case .Mainnet:
            return 1
        case .Ropsten:
            return 3
        case .Rinkeby:
            return 4
        case .Kovan:
            return 42
        case .Apothem:
            return 51
        case .Custom(let str):
            return Int(str) ?? 0
        }
    }
}

public func ==(lhs: XinfinNetwork, rhs: XinfinNetwork) -> Bool {
    return lhs.stringValue == rhs.stringValue
    
}
