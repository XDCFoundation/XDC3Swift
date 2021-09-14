//
//  XRC721Functions.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation
import BigInt

public enum XRC721Functions {
    public static var interfaceId: Data {
        return "0x80ac58cd".xdc3.hexData!
    }
    
    public struct balanceOf: ABIFunction {
        public static let name = "balanceOf"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: XDCAddress
        public let from: XDCAddress?
        
        public let owner: XDCAddress
        
        public init(contract: XDCAddress,
                    from: XDCAddress? = nil,
                    owner: XDCAddress,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil) {
            self.contract = contract
            self.from = from
            self.owner = owner
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(owner)
        }
    }
    
    public struct ownerOf: ABIFunction {
        public static let name = "ownerOf"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: XDCAddress
        public let from: XDCAddress?
        
        public let tokenId: BigUInt
        
        public init(contract: XDCAddress,
                    from: XDCAddress? = nil,
                    tokenId: BigUInt,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil) {
            self.contract = contract
            self.from = from
            self.tokenId = tokenId
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(tokenId)
        }
    }
    
    public struct getApproved: ABIFunction {
        public static let name = "getApproved"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: XDCAddress
        public let from: XDCAddress?
        
        public let tokenId: BigUInt
        
        public init(contract: XDCAddress,
                    from: XDCAddress? = nil,
                    tokenId: BigUInt,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil) {
            self.contract = contract
            self.from = from
            self.tokenId = tokenId
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(tokenId)
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
        public let tokenId: BigUInt
        
        public init(contract: XDCAddress,
                    from: XDCAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil,
                    sender: XDCAddress,
                    to: XDCAddress,
                    tokenId: BigUInt) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
            self.sender = sender
            self.to = to
            self.tokenId = tokenId
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(sender)
            try encoder.encode(to)
            try encoder.encode(tokenId)
        }
    }
    
    public struct isApprovedForAll: ABIFunction {
        public static let name = "isApprovedForAll"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: XDCAddress
        public let from: XDCAddress?
        
        public let opearator: XDCAddress
        public let owner: XDCAddress
        
        public init(contract: XDCAddress,
                    from: XDCAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil,
                    opearator: XDCAddress,
                    owner: XDCAddress
                    ) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
            self.owner = owner
            self.opearator = opearator
          
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(owner)
            try encoder.encode(opearator)
        }
    }
    
    public struct safeTransferFrom: ABIFunction {
        public static let name = "safeTransferFrom"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: XDCAddress
        public let from: XDCAddress?
        
        public let sender: XDCAddress
        public let to: XDCAddress
        public let tokenId: BigUInt
        
        public init(contract: XDCAddress,
                    from: XDCAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil,
                    sender: XDCAddress,
                    to: XDCAddress,
                    tokenId: BigUInt) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
            self.sender = sender
            self.to = to
            self.tokenId = tokenId
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(sender)
            try encoder.encode(to)
            try encoder.encode(tokenId)
        }
    }
    
    public struct safeTransferFromAndData: ABIFunction {
        public static let name = "safeTransferFrom"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: XDCAddress
        public let from: XDCAddress?
        
        public let sender: XDCAddress
        public let to: XDCAddress
        public let tokenId: BigUInt
        public let data: Data
        
        public init(contract: XDCAddress,
                    from: XDCAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil,
                    sender: XDCAddress,
                    to: XDCAddress,
                    tokenId: BigUInt,
                    data: Data) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
            self.sender = sender
            self.to = to
            self.tokenId = tokenId
            self.data = data
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(sender)
            try encoder.encode(to)
            try encoder.encode(tokenId)
            try encoder.encode(data)
        }
    }
    
    public struct setApprovalForAll: ABIFunction {
        public static let name = "setApprovalForAll"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: XDCAddress
        public let from: XDCAddress?
        
      
        public let to: XDCAddress
        public let approved: Bool
        
        public init(contract: XDCAddress,
                    from: XDCAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil,
                    to: XDCAddress,
                    approved: Bool) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
            self.to = to
            self.approved = approved
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(to)
            try encoder.encode(approved)
        }
    }
    
    public struct approve: ABIFunction {
        public static let name = "approve"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: XDCAddress
        public let from: XDCAddress?
        
        public let to: XDCAddress
        public let tokenId: BigUInt
        
        public init(contract: XDCAddress,
                    from: XDCAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil,
                    to: XDCAddress,
                    tokenId: BigUInt) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
            self.to = to
            self.tokenId = tokenId
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(to)
            try encoder.encode(tokenId)
        }
    }
}

public enum XRC721MetadataFunctions {
    public static var interfaceId: Data {
        return "name()".xdc3.keccak256.xdc3.bytes4 ^
            "symbol()".xdc3.keccak256.xdc3.bytes4 ^
            "tokenURI(uint256)".xdc3.keccak256.xdc3.bytes4
    }
    
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
 
    public struct tokenURI: ABIFunction {
        public static let name = "tokenURI"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: XDCAddress
        public let from: XDCAddress?
        
        public let tokenID: BigUInt
        
        public init(contract: XDCAddress,
                    from: XDCAddress? = nil,
                    tokenID: BigUInt,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil) {
            self.contract = contract
            self.from = from
            self.tokenID = tokenID
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(tokenID)
        }
    }
}

public enum XRC721EnumerableFunctions {
    public static var interfaceId: Data {
        return "totalSupply()".xdc3.keccak256.xdc3.bytes4 ^
            "tokenByIndex(uint256)".xdc3.keccak256.xdc3.bytes4 ^
            "tokenOfOwnerByIndex(address,uint256)".xdc3.keccak256.xdc3.bytes4
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
    
    public struct tokenByIndex: ABIFunction {
        public static let name = "tokenByIndex"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: XDCAddress
        public let from: XDCAddress?
        
        public let index: BigUInt
        
        public init(contract: XDCAddress,
                    from: XDCAddress? = nil,
                    index: BigUInt,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil) {
            self.contract = contract
            self.from = from
            self.index = index
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(index)
        }
    }
    
    public struct tokenOfOwnerByIndex: ABIFunction {
        public static let name = "tokenOfOwnerByIndex"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: XDCAddress
        public let from: XDCAddress?
        
        public let address: XDCAddress
        public let index: BigUInt
        
        public init(contract: XDCAddress,
                    from: XDCAddress? = nil,
                    address: XDCAddress,
                    index: BigUInt,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil) {
            self.contract = contract
            self.from = from
            self.address = address
            self.index = index
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(address)
            try encoder.encode(index)
        }
    }
}
