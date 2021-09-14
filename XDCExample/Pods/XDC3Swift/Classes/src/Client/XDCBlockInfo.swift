//
//  XDCBlockData.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation

public struct XDCBlockInfo: Equatable {
    public var number: XDCBlock
    public var timestamp: Date
    public var transactions: [String]
}

extension XDCBlockInfo: Codable {
    enum CodingKeys: CodingKey {
        case number
        case timestamp
        case transactions
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let number = try? container.decode(XDCBlock.self, forKey: .number) else {
            throw JSONRPCError.decodingError
        }
        
        guard let timestampRaw = try? container.decode(String.self, forKey: .timestamp),
            let timestamp = TimeInterval(timestampRaw) else {
                throw JSONRPCError.decodingError
        }
        
        guard let transactions = try? container.decode([String].self, forKey: .transactions) else {
            throw JSONRPCError.decodingError
        }
        
        self.number = number
        self.timestamp = Date(timeIntervalSince1970: timestamp)
        self.transactions = transactions
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(number, forKey: .number)
        try container.encode(Int(timestamp.timeIntervalSince1970).xdc3.hexString, forKey: .timestamp)
        try container.encode(transactions, forKey: .transactions)
    }
}

