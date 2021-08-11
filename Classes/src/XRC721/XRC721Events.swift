//
//  XRC721Events.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation
import BigInt

public enum XRC721Events {
    public struct Transfer: ABIEvent {
        public static let name = "Transfer"
        public static let types: [ABIType.Type] = [ XDCAddress.self , XDCAddress.self , BigUInt.self]
        public static let typesIndexed = [true, true, true]
        public let log: XDCLog
        
        public let from: XDCAddress
        public let to: XDCAddress
        public let tokenId: BigUInt
        
        public init?(topics: [ABIDecoder.DecodedValue], data: [ABIDecoder.DecodedValue], log: XDCLog) throws {
            try Transfer.checkParameters(topics, data)
            self.log = log
            
            self.from = try topics[0].decoded()
            self.to = try topics[1].decoded()
            self.tokenId = try topics[2].decoded()
        }
    }
    
    public struct Approval: ABIEvent {
        public static let name = "Approval"
        public static let types: [ABIType.Type] = [ XDCAddress.self , XDCAddress.self , BigUInt.self]
        public static let typesIndexed = [true, true, true]
        public let log: XDCLog
        
        public let from: XDCAddress
        public let approved: XDCAddress
        public let tokenId: BigUInt
        
        public init?(topics: [ABIDecoder.DecodedValue], data: [ABIDecoder.DecodedValue], log: XDCLog) throws {
            try Approval.checkParameters(topics, data)
            self.log = log
            
            self.from = try topics[0].decoded()
            self.approved = try topics[1].decoded()
            self.tokenId = try topics[2].decoded()
        }
    }
    
    public struct ApprovalForAll: ABIEvent {
        public static let name = "ApprovalForAll"
        public static let types: [ABIType.Type] = [ XDCAddress.self , XDCAddress.self , BigUInt.self]
        public static let typesIndexed = [true, true, true]
        public let log: XDCLog
        
        public let from: XDCAddress
        public let `operator`: XDCAddress
        public let approved: Bool
        
        public init?(topics: [ABIDecoder.DecodedValue], data: [ABIDecoder.DecodedValue], log: XDCLog) throws {
            try ApprovalForAll.checkParameters(topics, data)
            self.log = log
            
            self.from = try topics[0].decoded()
            self.operator = try topics[1].decoded()
            self.approved = try topics[2].decoded()
        }
    }
}
