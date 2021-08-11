//
//  XRC20Functions.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation
import BigInt

public enum XRC20Functions {
    public struct name: ABIFunction {
        public static let name = "name"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: XDCAddress
        public let from: XDCAddress?
        
        public init(contract: XDCAddress,
                    from: XDCAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws { }
    }
    
    public struct symbol: ABIFunction {
        public static let name = "symbol"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: XDCAddress
        public let from: XDCAddress?
        
        public init(contract: XDCAddress,
                    from: XDCAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws { }
    }
    
    public struct decimals: ABIFunction {
        public static let name = "decimals"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: XDCAddress
        public let from: XDCAddress?
        
        public init(contract: XDCAddress,
                    from: XDCAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws { }
    }
    public struct totalSupply: ABIFunction {
        public static let name = "totalSupply"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: XDCAddress
        public let from: XDCAddress?
        
        public init(contract: XDCAddress,
                    from: XDCAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws { }
    }
    
    public struct balanceOf: ABIFunction {
        public static let name = "balanceOf"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: XDCAddress
        public let from: XDCAddress?
        
        public let account: XDCAddress
        
        public init(contract: XDCAddress,
                    from: XDCAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil,
                    account: XDCAddress ) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
            self.account = account
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(account) 
        }
    }
    
    public struct allowance: ABIFunction {
        public static let name = "allowance"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: XDCAddress
        public let from: XDCAddress?
        
        public let owner: XDCAddress
        public let spender: XDCAddress
        
        public init(contract: XDCAddress,
                    from: XDCAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil,
                    owner: XDCAddress,
                    spender: XDCAddress) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
            self.owner = owner
            self.spender = spender
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(owner)
            try encoder.encode(spender)
        }
    }
    
    public struct approve: ABIFunction {
        public static let name = "approve"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: XDCAddress
        public let from: XDCAddress?
        
        public let spender: XDCAddress
        public let value: BigUInt
        
        public init(contract: XDCAddress,
                    from: XDCAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil,
                    spender: XDCAddress,
                    value: BigUInt) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
            self.spender = spender
            self.value = value
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(spender)
            try encoder.encode(value)
        }
    }
    
    public struct transfer: ABIFunction {
        public static let name = "transfer"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: XDCAddress
        public let from: XDCAddress?
        
        public let to: XDCAddress
        public let value: BigUInt
        
        public init(contract: XDCAddress,
                    from: XDCAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil,
                    to: XDCAddress,
                    value: BigUInt) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
            self.to = to
            self.value = value
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(to)
            try encoder.encode(value)
        }
    }
    
    public struct transferFrom: ABIFunction {
        public static let name = "transferFrom"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: XDCAddress
        public let from: XDCAddress?
        
        public let sender: XDCAddress
        public let to: XDCAddress
        public let value: BigUInt
        
        public init(contract: XDCAddress,
                    from: XDCAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil,
                    sender: XDCAddress,
                    to: XDCAddress,
                    value: BigUInt) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
            self.sender = sender
            self.to = to
            self.value = value
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(sender)
            try encoder.encode(to)
            try encoder.encode(value)
        }
    }
}

