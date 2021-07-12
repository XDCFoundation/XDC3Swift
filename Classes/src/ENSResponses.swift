//
//  ENSRegistryResponses.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation

extension ENSContracts {
    enum ENSRegistryResponses {
        struct RegistryResponse: MulticallDecodableResponse {
            var value: XinfinAddress

            init?(data: String) throws {
                guard data != "0x" else {
                    throw XinfinNameServiceError.ensUnknown
                }

                let idx = data.index(data.endIndex, offsetBy: -40)
                self.value = XinfinAddress(String(data[idx...]).web3.withHexPrefix)

                guard self.value != .zero else {
                    throw XinfinNameServiceError.ensUnknown
                }
            }
        }

        struct AddressResolverResponse: ABIResponse, MulticallDecodableResponse {
            static var types: [ABIType.Type] { [String.self] }

            var value: String

            init?(values: [ABIDecoder.DecodedValue]) throws {
                self.value = try values[0].decoded()
            }
        }

        struct NameResolverResponse: ABIResponse, MulticallDecodableResponse {
            static var types: [ABIType.Type] { [XinfinAddress.self] }

            var value: XinfinAddress

            init?(values: [ABIDecoder.DecodedValue]) throws {
                self.value = try values[0].decoded()
            }
        }
    }
}
