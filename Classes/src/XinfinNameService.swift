//
//  XinfinNameService.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation

protocol XinfinNameServiceProtocol {
    init(client: XinfinClientProtocol, registryAddress: XinfinAddress?)
    func resolve(address: XinfinAddress, completion: @escaping((XinfinNameServiceError?, String?) -> Void)) -> Void
    func resolve(ens: String, completion: @escaping((XinfinNameServiceError?, XinfinAddress?) -> Void)) -> Void
}

public enum XinfinNameServiceError: Error, Equatable {
    case noNetwork
    case noResolver
    case ensUnknown
    case invalidInput
    case decodeIssue
}

// This is an example of interacting via a JSON Definition contract API
public class XinfinNameService: XinfinNameServiceProtocol {
    let client: XinfinClientProtocol
    let registryAddress: XinfinAddress?
    
    required public init(client: XinfinClientProtocol, registryAddress: XinfinAddress? = nil) {
        self.client = client
        self.registryAddress = registryAddress
    }

    public func resolve(address: XinfinAddress, completion: @escaping ((XinfinNameServiceError?, String?) -> Void)) {
        guard
            let network = client.network,
            let registryAddress = self.registryAddress ?? ENSContracts.registryAddress(for: network) else {
            return completion(XinfinNameServiceError.noNetwork, nil)
        }
        
        let ensReverse = address.value.web3.noHexPrefix + ".addr.reverse"
        let nameHash = Self.nameHash(name: ensReverse)
        
        let function = ENSContracts.ENSRegistryFunctions.resolver(contract: registryAddress,
                                                                  _node: nameHash.web3.hexData ?? Data())
        guard let registryTransaction = try? function.transaction() else {
            completion(XinfinNameServiceError.invalidInput, nil)
            return
        }

        client.eth_call(registryTransaction, block: .Latest, completion: { (error, resolverData) in
            guard let resolverData = resolverData else {
                return completion(XinfinNameServiceError.noResolver, nil)
            }
            
            guard resolverData != "0x" else {
                return completion(XinfinNameServiceError.ensUnknown, nil)
            }
            
            let idx = resolverData.index(resolverData.endIndex, offsetBy: -40)
            let resolverAddress = XinfinAddress(String(resolverData[idx...]).web3.withHexPrefix)
            
            let function = ENSContracts.ENSResolverFunctions.name(contract: resolverAddress,
                                                                  _node: nameHash.web3.hexData ?? Data())
            guard let addressTransaction = try? function.transaction() else {
                completion(XinfinNameServiceError.invalidInput, nil)
                return
            }
            
            self.client.eth_call(addressTransaction, block: .Latest, completion: { (error, data) in
                guard let data = data, data != "0x" else {
                    return completion(XinfinNameServiceError.ensUnknown, nil)
                }
                if let ensHex: String = try? (try? ABIDecoder.decodeData(data, types: [String.self]))?.first?.decoded() {
                    completion(nil, ensHex)
                } else {
                    completion(XinfinNameServiceError.decodeIssue, nil)
                }
                
            })
        })
    }
    
    public func resolve(ens: String, completion: @escaping ((XinfinNameServiceError?, XinfinAddress?) -> Void)) {
        
        guard
            let network = client.network,
            let registryAddress = self.registryAddress ?? ENSContracts.registryAddress(for: network) else {
            return completion(XinfinNameServiceError.noNetwork, nil)
        }
        let nameHash = Self.nameHash(name: ens)
        let function = ENSContracts.ENSRegistryFunctions.resolver(contract: registryAddress,
                                                                  _node: nameHash.web3.hexData ?? Data())
        
        guard let registryTransaction = try? function.transaction() else {
            completion(XinfinNameServiceError.invalidInput, nil)
            return
        }

        client.eth_call(registryTransaction, block: .Latest, completion: { (error, resolverData) in
            guard let resolverData = resolverData else {
                return completion(XinfinNameServiceError.noResolver, nil)
            }
            
            guard resolverData != "0x" else {
                return completion(XinfinNameServiceError.ensUnknown, nil)
            }
            
            let idx = resolverData.index(resolverData.endIndex, offsetBy: -40)
            let resolverAddress = XinfinAddress(String(resolverData[idx...]).web3.withHexPrefix)
            
            let function = ENSContracts.ENSResolverFunctions.addr(contract: resolverAddress, _node: nameHash.web3.hexData ?? Data())
            guard let addressTransaction = try? function.transaction() else {
                completion(XinfinNameServiceError.invalidInput, nil)
                return
            }
            
            self.client.eth_call(addressTransaction, block: .Latest, completion: { (error, data) in
                guard let data = data, data != "0x" else {
                    return completion(XinfinNameServiceError.ensUnknown, nil)
                }
                
                if let ensAddress: XinfinAddress = try? (try? ABIDecoder.decodeData(data, types: [XinfinAddress.self]))?.first?.decoded() {
                    completion(nil, ensAddress)
                } else {
                    completion(XinfinNameServiceError.decodeIssue, nil)
                }
            })
        })
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
