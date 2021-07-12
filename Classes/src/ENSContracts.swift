//
//  ENSContracts.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation
import BigInt

public typealias ENSRegistryResolverParameter = ENSContracts.ENSRegistryFunctions.resolver.Parameter

public enum ENSContracts {
    static let RopstenAddress = XinfinAddress("0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e")
    static let MainnetAddress = XinfinAddress("0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e")
    static let ApothemAddress = XinfinAddress("xdcef4ba943405d6b75416c9a2f0363a31b88045aad")
    
    public static func registryAddress(for network: XinfinNetwork) -> XinfinAddress? {
        switch network {
        case .Ropsten:
            return ENSContracts.RopstenAddress
        case .Mainnet:
            return ENSContracts.MainnetAddress
        case .Apothem:
            return ENSContracts.ApothemAddress
        default:
            return nil
        }
    }
    
    public enum ENSResolverFunctions {
        public struct addr: ABIFunction {
            public static let name = "addr"
            public let gasPrice: BigUInt?
            public let gasLimit: BigUInt?
            public var contract: XinfinAddress
            public let from: XinfinAddress?
            
            public let _node: Data
            
            public init(contract: XinfinAddress,
                 from: XinfinAddress? = nil,
                 gasPrice: BigUInt? = nil,
                 gasLimit: BigUInt? = nil,
                 _node: Data) {
                self.contract = contract
                self.from = from
                self.gasPrice = gasPrice
                self.gasLimit = gasLimit
                self._node = _node
            }
            
            public func encode(to encoder: ABIFunctionEncoder) throws {
                try encoder.encode(_node, staticSize: 32)
            }
        }
        
        public struct name: ABIFunction {
            public static let name = "name"
            public let gasPrice: BigUInt?
            public let gasLimit: BigUInt?
            public var contract: XinfinAddress
            public let from: XinfinAddress?
            
            public let _node: Data
            
            init(contract: XinfinAddress,
                 from: XinfinAddress? = nil,
                 gasPrice: BigUInt? = nil,
                 gasLimit: BigUInt? = nil,
                 _node: Data) {
                self.contract = contract
                self.from = from
                self.gasPrice = gasPrice
                self.gasLimit = gasLimit
                self._node = _node
            }
            
            public func encode(to encoder: ABIFunctionEncoder) throws {
                try encoder.encode(_node, staticSize: 32)
            }
        }
    }
    
    public enum ENSRegistryFunctions {
        public struct resolver: ABIFunction {

            public enum Parameter {
                case address(XinfinAddress)
                case name(String)

                var nameHash: Data {
                    let nameHash: String
                    switch self {
                    case .address(let address):
                        nameHash = ENSContracts.nameHash(name: address.value.web3.noHexPrefix + ".addr.reverse")
                    case .name(let ens):
                        nameHash = ENSContracts.nameHash(name: ens)
                    }
                    return nameHash.web3.xdcData ?? Data()
                }

                var name: String? {
                    switch self {
                    case .name(let ens):
                        return ens
                    case .address:
                        return nil
                    }
                }

                var address: XinfinAddress? {
                    switch self {
                    case .address(let address):
                        return address
                    case .name:
                        return nil
                    }
                }
            }

            public static let name = "resolver"
            public let gasPrice: BigUInt?
            public let gasLimit: BigUInt?
            public var contract: XinfinAddress
            public let from: XinfinAddress?
            
            let _node: Data
            
            init(contract: XinfinAddress,
                 from: XinfinAddress? = nil,
                 gasPrice: BigUInt? = nil,
                 gasLimit: BigUInt? = nil,
                 _node: Data) {
                self.contract = contract
                self.from = from
                self.gasPrice = gasPrice
                self.gasLimit = gasLimit
                self._node = _node
            }

            public init(contract: XinfinAddress,
                        from: XinfinAddress? = nil,
                        gasPrice: BigUInt? = nil,
                        gasLimit: BigUInt? = nil,
                        parameter: Parameter) {
                self.init(
                    contract: contract,
                    from: from,
                    gasPrice: gasPrice,
                    gasLimit: gasLimit,
                    _node: parameter.nameHash
                )
            }
            
            public func encode(to encoder: ABIFunctionEncoder) throws {
                try encoder.encode(_node, staticSize: 32)
            }
        }
        
        struct owner: ABIFunction {
            static let name = "owner"
            let gasPrice: BigUInt?
            let gasLimit: BigUInt?
            var contract: XinfinAddress
            let from: XinfinAddress?
            
            let _node: Data
            
            init(contract: XinfinAddress,
                 from: XinfinAddress? = nil,
                 gasPrice: BigUInt? = nil,
                 gasLimit: BigUInt? = nil,
                 _node: Data) {
                self.contract = contract
                self.from = from
                self.gasPrice = gasPrice
                self.gasLimit = gasLimit
                self._node = _node
            }
            
            public func encode(to encoder: ABIFunctionEncoder) throws {
                try encoder.encode(_node, staticSize: 32)
            }
        }
    }

    static func nameHash(name: String) -> String {
        var node = Data.init(count: 32)
        let labels = name.components(separatedBy: ".")
        for label in labels.reversed() {
            node.append(label.web3.keccak256)
            node = node.web3.keccak256
        }
        return node.web3.hexString
    }
}
