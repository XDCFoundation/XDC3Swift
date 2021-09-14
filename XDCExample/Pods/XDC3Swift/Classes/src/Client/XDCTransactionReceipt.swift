//
//  TransactionReceipt.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation
import BigInt

public enum XDCTransactionReceiptStatus: Int {
    case success = 1
    case failure = 0
    case notProcessed = -1
}

public struct XDCTransactionReceipt: Decodable {
    public var transactionHash: String
    public var transactionIndex: BigUInt
    public var blockHash: String
    public var blockNumber: BigUInt
    public var gasUsed: BigUInt
    public var contractAddress: XDCAddress?
    public var logs: Array<XDCLog> = []
    var logsBloom: Data?
    public var status: XDCTransactionReceiptStatus
    
    enum CodingKeys: String, CodingKey {
        case transactionHash    // Data
        case transactionIndex   // Quantity
        case blockHash          // Data
        case blockNumber        // Quantity
        case cumulativeGasUsed  // Quantity
        case gasUsed            // Quantity
        case contractAddress    // Data or null
        case logs               // Array
        case logsBloom          // Data
        case status             // Quantity (success 1 or failure 0)
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.transactionHash = try values.decode(String.self, forKey: .transactionHash)
        self.blockHash = try values.decode(String.self, forKey: .blockHash)
        self.contractAddress = try? values.decode(XDCAddress.self, forKey: .contractAddress)
        
        let transactionIndexString = try values.decode(String.self, forKey: .transactionIndex)
        let blockNumberString = try values.decode(String.self, forKey: .blockNumber)
        let gasUsedString = try values.decode(String.self, forKey: .gasUsed)
        let logsBloomString = try values.decode(String.self, forKey: .logsBloom)
        let statusString = try values.decode(String.self, forKey: .status)
        
        guard let transactionIndex = BigUInt(hex: transactionIndexString), let blockNumber = BigUInt(hex: blockNumberString), let gasUsed = BigUInt(hex: gasUsedString), let statusCode = Int(hex: statusString) else {
            throw XDCClientError.decodeIssue
        }
        
        self.transactionIndex = transactionIndex
        self.blockNumber = blockNumber
        self.gasUsed = gasUsed
        self.logsBloom = Data(hex: logsBloomString) ?? nil
        self.status = XDCTransactionReceiptStatus(rawValue: statusCode) ?? .notProcessed
        
        self.logs = try values.decode([XDCLog].self, forKey: .logs)
    }
    
}
