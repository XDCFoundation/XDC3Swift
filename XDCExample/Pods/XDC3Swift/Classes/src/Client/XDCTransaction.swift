//
//  XDCTransaction.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation
import BigInt

public protocol XDCTransactionProtocol {
    init(from: XDCAddress?, to: XDCAddress, value: BigUInt?, data: Data?, nonce: Int?, gasPrice: BigUInt?, gasLimit: BigUInt?, chainId: Int?)
    init(from: XDCAddress?, to: XDCAddress, data: Data, gasPrice: BigUInt, gasLimit: BigUInt)
    init(to: XDCAddress, data: Data)
    
    var raw: Data? { get }
    var hash: Data? { get }
}

public struct XDCTransaction: XDCTransactionProtocol, Equatable, Codable {
    public let from: XDCAddress?
    public let to: XDCAddress
    public let value: BigUInt?
    public let data: Data?
    public var nonce: Int?
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public let gas: BigUInt?
    public let blockNumber: XDCBlock?
    public private(set) var hash: Data?
    var chainId: Int? {
        didSet {
            self.hash = self.raw?.xdc3.keccak256
        }
    }
    
    public init(from: XDCAddress?, to: XDCAddress, value: BigUInt?, data: Data?, nonce: Int?, gasPrice: BigUInt?, gasLimit: BigUInt?, chainId: Int?) {
        self.from = from
        self.to = to
        self.value = value
        self.data = data ?? Data()
        self.nonce = nonce
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.chainId = chainId
        self.gas = nil
        self.blockNumber = nil
        let txArray: [Any?] = [self.nonce, self.gasPrice, self.gasLimit, self.to.value.xdc3.noHexPrefix, self.value, self.data, self.chainId, 0, 0]
        self.hash = RLP.encode(txArray)
    }
    
    public init(from: XDCAddress?, to: XDCAddress, data: Data, gasPrice: BigUInt, gasLimit: BigUInt) {
        self.from = from
        self.to = to
        self.value = BigUInt(0)
        self.data = data
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.gas = nil
        self.blockNumber = nil
        self.hash = nil
    }
    
    public init(to: XDCAddress, data: Data) {
        self.from = nil
        self.to = to
        self.value = BigUInt(0)
        self.data = data
        self.gasPrice = BigUInt(0)
        self.gasLimit = BigUInt(0)
        self.gas = nil
        self.blockNumber = nil
        self.hash = nil
    }
    
    public var raw: Data? {
        let txArray: [Any?] = [self.nonce, self.gasPrice, self.gasLimit, self.to.value.xdc3.noHexPrefix, self.value, self.data, self.chainId, 0, 0]

        return RLP.encode(txArray)
    }
    
    enum CodingKeys : String, CodingKey {
        case from
        case to
        case value
        case data
        case nonce
        case gasPrice
        case gas
        case gasLimit
        case blockNumber
        case hash
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.to = try container.decode(XDCAddress.self, forKey: .to)
        self.from = try? container.decode(XDCAddress.self, forKey: .from)
        self.data = try? container.decode(Data.self, forKey: .data)
        
        let decodeHexUInt = { (key: CodingKeys) -> BigUInt? in
            return (try? container.decode(String.self, forKey: key)).flatMap { BigUInt(hex: $0)}
        }
        
        let decodeHexInt = { (key: CodingKeys) -> Int? in
            return (try? container.decode(String.self, forKey: key)).flatMap { Int(hex: $0)}
        }
        
        self.value = decodeHexUInt(.value)
        self.gasLimit = decodeHexUInt(.gasLimit)
        self.gasPrice = decodeHexUInt(.gasPrice)
        self.gas = decodeHexUInt(.gas)
        self.nonce = decodeHexInt(.nonce)
        self.blockNumber = try? container.decode(XDCBlock.self, forKey: .blockNumber)
        self.hash = (try? container.decode(String.self, forKey: .hash))?.xdc3.hexData
        self.chainId = nil
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(to, forKey: .to)
        try? container.encode(from, forKey: .from)
        try? container.encode(data, forKey: .data)
        try? container.encode(value?.xdc3.hexString, forKey: .value)
        try? container.encode(gasPrice?.xdc3.hexString, forKey: .gasPrice)
        try? container.encode(gasLimit?.xdc3.hexString, forKey: .gasLimit)
        try? container.encode(gas?.xdc3.hexString, forKey: .gas)
        try? container.encode(nonce?.xdc3.hexString, forKey: .nonce)
        try? container.encode(blockNumber, forKey: .blockNumber)
        try? container.encode(hash?.xdc3.hexString, forKey: .hash)
    }
}

struct SignedTransaction {
    let transaction: XDCTransaction
    let v: Int
    let r: Data
    let s: Data
    
    init(transaction: XDCTransaction, v: Int, r: Data, s: Data) {
        self.transaction = transaction
        self.v = v
        self.r = r.xdc3.strippingZeroesFromBytes
        self.s = s.xdc3.strippingZeroesFromBytes
    }
    
    var raw: Data? {
        let txArray: [Any?] = [transaction.nonce, transaction.gasPrice, transaction.gasLimit, transaction.to.value.xdc3.noHexPrefix, transaction.value, transaction.data, self.v, self.r, self.s]

        return RLP.encode(txArray)
    }
    
    var hash: Data? {
        return raw?.xdc3.keccak256
    }
}
