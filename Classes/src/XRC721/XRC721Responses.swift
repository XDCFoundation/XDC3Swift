//
//  XRC721Responses.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation
import BigInt

public enum XRC721Responses {
    public struct balanceResponse: ABIResponse {
        public static var types: [ABIType.Type] = [ BigUInt.self ]
        public let value: BigUInt
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
    
    public struct ownerResponse: ABIResponse {
        public static var types: [ABIType.Type] = [ XDCAddress.self ]
        public let value: XDCAddress
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
    
    public struct getApproved: ABIResponse {
        public static var types: [ABIType.Type] = [ XDCAddress.self ]
        public let value: XDCAddress
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
    
    public struct safeTransferFrom: ABIResponse {
        public static var types: [ABIType.Type] = [ XDCAddress.self ]
        public let value: XDCAddress
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
    
    public struct TransferFrom: ABIResponse {
        public static var types: [ABIType.Type] = [ BigUInt.self ]
        public let value: BigUInt
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
    
    public struct isApprovedForAll: ABIResponse {
        public static var types: [ABIType.Type] = [ Bool.self ]
        public let value: Bool
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
}

public enum XRC721MetadataResponses {
    public struct nameResponse: ABIResponse {
        public static var types: [ABIType.Type] = [ String.self ]
        public let value: String
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
    
    public struct symbolResponse: ABIResponse {
        public static var types: [ABIType.Type] = [ String.self ]
        public let value: String
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
    
    public struct tokenURIResponse: ABIResponse {
        public static var types: [ABIType.Type] = [ URL.self ]

        @available(*, deprecated, renamed: "value")
        public var uri: URL { value }

        public let value: URL
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
}

public enum XRC721EnumerableResponses {
    public struct numberResponse: ABIResponse {
        public static var types: [ABIType.Type] = [ BigUInt.self ]
        public let value: BigUInt
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
}
