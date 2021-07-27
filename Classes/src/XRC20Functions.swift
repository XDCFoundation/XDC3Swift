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
        public var contract: XinfinAddress
        public let from: XinfinAddress?
        
        public init(contract: XinfinAddress,
                    from: XinfinAddress? = nil,
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
        public var contract: XinfinAddress
        public let from: XinfinAddress?
        
        public init(contract: XinfinAddress,
                    from: XinfinAddress? = nil,
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
        public var contract: XinfinAddress
        public let from: XinfinAddress?
        
        public init(contract: XinfinAddress,
                    from: XinfinAddress? = nil,
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
        public var contract: XinfinAddress
        public let from: XinfinAddress?
        
        public init(contract: XinfinAddress,
                    from: XinfinAddress? = nil,
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
        public var contract: XinfinAddress
        public let from: XinfinAddress?
        
        public let account: XinfinAddress
        
        public init(contract: XinfinAddress,
                    from: XinfinAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil,
                    account: XinfinAddress ) {
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
        public var contract: XinfinAddress
        public let from: XinfinAddress?
        
        public let owner: XinfinAddress
        public let spender: XinfinAddress
        
        public init(contract: XinfinAddress,
                    from: XinfinAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil,
                    owner: XinfinAddress,
                    spender: XinfinAddress) {
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
        public var contract: XinfinAddress
        public let from: XinfinAddress?
        
        public let spender: XinfinAddress
        public let value: BigUInt
        
        public init(contract: XinfinAddress,
                    from: XinfinAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil,
                    spender: XinfinAddress,
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
        public var contract: XinfinAddress
        public let from: XinfinAddress?
        
        public let to: XinfinAddress
        public let value: BigUInt
        
        public init(contract: XinfinAddress,
                    from: XinfinAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil,
                    to: XinfinAddress,
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
        public var contract: XinfinAddress
        public let from: XinfinAddress?
        
        public let sender: XinfinAddress
        public let to: XinfinAddress
        public let value: BigUInt
        
        public init(contract: XinfinAddress,
                    from: XinfinAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil,
                    sender: XinfinAddress,
                    to: XinfinAddress,
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

