//
//  XRC165.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation
import BigInt

public class XRC165 {
    public let client: XDCClient
    public init(client: XDCClient) {
        self.client = client
    }
    /*
     Query if a contract implements an interface
     @param interfaceID The interface identifier, as specified in XRC-165
     @return `true` if the contract implements `interfaceID` and
     `interfaceID` is not 0xffffffff, `false` otherwise
     */
    public func supportsInterface(contract: XDCAddress,
                                  id: Data,
                                  completion: @escaping((Error?, Bool?) -> Void)) {
        let function = XRC165Functions.supportsInterface(contract: contract, interfaceId: id)
        function.call(withClient: self.client,
                      responseType: XRC165Responses.supportsInterfaceResponse.self) { (error, response) in
            return completion(error, response?.supported)
        }
    }

}

public enum XRC165Functions {
    public static var interfaceId: Data {
        return "supportsInterface(bytes4)".xdc3.keccak256.xdc3.bytes4
    }
    
    struct supportsInterface: ABIFunction {
        public static let name = "supportsInterface"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: XDCAddress
        public let from: XDCAddress?
        
        let interfaceId: Data
        
        public init(contract: XDCAddress,
                    from: XDCAddress? = nil,
                    interfaceId: Data,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil) {
            self.contract = contract
            self.from = from
            self.interfaceId = interfaceId
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            assert(interfaceId.count == 4, "Interface data should contain exactly 4 bytes")
            try encoder.encode(interfaceId, staticSize: 4)
        }
    }
}

public enum XRC165Responses {
    public struct supportsInterfaceResponse: ABIResponse {
        public static var types: [ABIType.Type] = [ Bool.self ]
        public let supported: Bool
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.supported = try values[0].decoded()
        }
    }
}
