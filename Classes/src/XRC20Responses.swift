//
//  XRC20Responses.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation
import BigInt

public enum XRC20Responses {
    public struct nameResponse: ABIResponse, MulticallDecodableResponse {
        public static var types: [ABIType.Type] = [ String.self ]
        public let value: String
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
    
    public struct symbolResponse: ABIResponse, MulticallDecodableResponse {
        public static var types: [ABIType.Type] = [ String.self ]
        public let value: String
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
    
    public struct decimalsResponse: ABIResponse, MulticallDecodableResponse {
        public static var types: [ABIType.Type] = [ UInt8.self ]
        public let value: UInt8
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
    public struct totalSupplyResponse: ABIResponse, MulticallDecodableResponse {
        public static var types: [ABIType.Type] = [ UInt8.self ]
        public let value: UInt8
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
    public struct numberResponse: ABIResponse, MulticallDecodableResponse {
        public static var types: [ABIType.Type] = [ BigUInt.self ]
        public let value: BigUInt
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }

    public struct balanceResponse: ABIResponse, MulticallDecodableResponse {
        public static var types: [ABIType.Type] = [ BigUInt.self ]
        public let value: BigUInt
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
    public struct allowance: ABIResponse{
        public static var types: [ABIType.Type] = [ BigUInt.self ]
        public let value: BigUInt
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
    public struct transfer: ABIResponse{
        public static var types: [ABIType.Type] = [ BigUInt.self ]
        public let value: BigUInt
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
    public struct approve: ABIResponse{
        public static var types: [ABIType.Type] = [ BigUInt.self ]
        public let value: BigUInt
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
    
    public struct transferFrom: ABIResponse{
        public static var types: [ABIType.Type] = [ BigUInt.self ]
        public let value: BigUInt
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
    
    public struct increaseAllowance: ABIResponse{
        public static var types: [ABIType.Type] = [ BigUInt.self ]
        public let value: BigUInt
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
    
    public struct decreaseAllowance: ABIResponse{
        public static var types: [ABIType.Type] = [ BigUInt.self ]
        public let value: BigUInt
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
}
