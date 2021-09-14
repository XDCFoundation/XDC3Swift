//
//  XRC20Events.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation
import BigInt

public enum XRC20Events {
    public struct Transfer: ABIEvent {
        public static let name = "Transfer"
        public static let types: [ABIType.Type] = [ XDCAddress.self , XDCAddress.self , BigUInt.self]
        public static let typesIndexed = [true, true, false]
        public let log: XDCLog
        
        public let from: XDCAddress
        public let to: XDCAddress
        public let value: BigUInt
        
        public init?(topics: [ABIDecoder.DecodedValue], data: [ABIDecoder.DecodedValue], log: XDCLog) throws {
            try Transfer.checkParameters(topics, data)
            self.log = log
            
            self.from = try topics[0].decoded()
            self.to = try topics[1].decoded()
            
            self.value = try data[0].decoded()
        }
    }
}
