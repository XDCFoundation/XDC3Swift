//
//  ENSMultiResolver.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation

extension XinfinNameService {

    public func resolve(
        addresses: [XinfinAddress],
        completion: @escaping (Result<[AddressResolveOutput], XinfinNameServiceError>) -> Void
    ) {
        MultiResolver(
            client: client,
            registryAddress: registryAddress
        ).resolve(addresses: addresses, completion: completion)
    }

    public func resolve(
        names: [String],
        completion: @escaping (Result<[NameResolveOutput], XinfinNameServiceError>) -> Void
    ) {
        MultiResolver(
            client: client,
            registryAddress: registryAddress
        ).resolve(names: names, completion: completion)
    }
}

extension XinfinNameService {

    public enum ResolveOutput<Value: Equatable>: Equatable {
        case couldNotBeResolved(XinfinNameServiceError)
        case resolved(Value)
    }

    public struct AddressResolveOutput: Equatable {
        public let address: XinfinAddress
        public let output: ResolveOutput<String>
    }

    public struct NameResolveOutput: Equatable {
        public let ens: String
        public let output: ResolveOutput<XinfinAddress>
    }

    private class MultiResolver {

        private class RegistryOutput<ResolveOutput> {
            var queries: [ResolverQuery] = []
            var intermediaryResponses: [ResolveOutput?]

            init(expectedResponsesCount: Int) {
                intermediaryResponses = Array(repeating: nil, count: expectedResponsesCount)
            }
        }

        private struct ResolverQuery {
            let index: Int
            let parameter: ENSRegistryResolverParameter
            let resolverAddress: XinfinAddress
            let nameHash: Data
        }

        let client: XinfinClientProtocol
        let registryAddress: XinfinAddress?
        let multicall: Multicall

        init(
            client: XinfinClientProtocol,
            registryAddress: XinfinAddress? = nil
        ) {
            self.client = client
            self.registryAddress = registryAddress
            self.multicall = Multicall(client: client)
        }

        func resolve(
            addresses: [XinfinAddress],
            completion: @escaping (Result<[AddressResolveOutput], XinfinNameServiceError>) -> Void
        ) {
            let output = RegistryOutput<AddressResolveOutput>(expectedResponsesCount: addresses.count)

            resolveRegistry(
                parameters: addresses.map(ENSRegistryResolverParameter.address),
                handler: { index, parameter, result in
                    // TODO: Temporary solution
                    guard let address = parameter.address else { return }
                    switch result {
                    case .success(let resolverAddress):
                        output.queries.append(
                            ResolverQuery(
                                index: index,
                                parameter: parameter,
                                resolverAddress: resolverAddress,
                                nameHash: parameter.nameHash
                            )
                        )
                    case .failure(let error):
                        output.intermediaryResponses[index] = AddressResolveOutput(
                            address: address,
                            output: Self.output(from: error)
                        )
                    }
                }, completion: { result  in
                    switch result {
                    case .success:
                        self.resolveQueries(registryOutput: output) { result in
                            switch result {
                            case .success(let output):
                                completion(.success(output))
                            case .failure:
                                completion(result)
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
        }

        func resolve(
            names: [String],
            completion: @escaping (Result<[NameResolveOutput], XinfinNameServiceError>) -> Void
        ) {
            let output = RegistryOutput<NameResolveOutput>(expectedResponsesCount: names.count)

            resolveRegistry(
                parameters: names.map(ENSRegistryResolverParameter.name),
                handler: { index, parameter, result in
                    // TODO: Temporary solution
                    guard let name = parameter.name else { return }
                    switch result {
                    case .success(let resolverAddress):
                        output.queries.append(
                            ResolverQuery(
                                index: index,
                                parameter: parameter,
                                resolverAddress: resolverAddress,
                                nameHash: parameter.nameHash
                            )
                        )
                    case .failure(let error):
                        output.intermediaryResponses[index] = NameResolveOutput(
                            ens: name,
                            output: Self.output(from: error)
                        )
                    }
                }, completion: { result  in
                    switch result {
                    case .success:
                        self.resolveQueries(registryOutput: output) { result in
                            switch result {
                            case .success(let output):
                                completion(.success(output))
                            case .failure:
                                completion(result)
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
        }

        private func resolveRegistry(
            parameters: [ENSRegistryResolverParameter],
            handler: @escaping (Int, ENSRegistryResolverParameter, Result<XinfinAddress, Multicall.CallError>) -> Void,
            completion: @escaping (Result<Void, XinfinNameServiceError>) -> Void
        ) {

            guard
                let network = client.network,
                let ensRegistryAddress = self.registryAddress ?? ENSContracts.registryAddress(for: network)
            else { return completion(.failure(.noNetwork)) }


            var aggegator = Multicall.Aggregator()

            do {
                try parameters.enumerated().forEach { index, parameter in

                    let function = ENSContracts.ENSRegistryFunctions.resolver(contract: ensRegistryAddress, parameter: parameter)

                    try aggegator.append(
                        function: function,
                        response: ENSContracts.ENSRegistryResponses.RegistryResponse.self
                    ) { result in handler(index, parameter, result) }
                }

                multicall.aggregate(calls: aggegator.calls) { result in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure:
                        completion(.failure(.noNetwork))
                    }
                }
            } catch {
                completion(.failure(.invalidInput))
            }
        }

        private func resolveQueries<ResolverOutput>(
            registryOutput: RegistryOutput<ResolverOutput>,
            completion: @escaping (Result<[ResolverOutput], XinfinNameServiceError>) -> Void
        ) {
            var aggegator = Multicall.Aggregator()

            registryOutput.queries.forEach { query in
                switch query.parameter {
                case .address(let address):
                    guard let registryOutput = registryOutput as? RegistryOutput<AddressResolveOutput>
                        else { fatalError("Invalid registry output provided") }
                    resolveAddress(query, address: address, aggegator: &aggegator, registryOutput: registryOutput)
                case .name(let name):
                    guard let registryOutput = registryOutput as? RegistryOutput<NameResolveOutput>
                        else { fatalError("Invalid registry output provided") }
                    resolveName(query, ens: name, aggegator: &aggegator, registryOutput: registryOutput)
                }
            }

            multicall.aggregate(calls: aggegator.calls) { result in
                switch result {
                case .success:
                    completion(.success(registryOutput.intermediaryResponses.compactMap { $0 }))
                case .failure:
                    completion(.failure(.noNetwork))
                }
            }
        }

        private func resolveAddress(
            _ query: XinfinNameService.MultiResolver.ResolverQuery,
            address: XinfinAddress,
            aggegator: inout Multicall.Aggregator,
            registryOutput: RegistryOutput<AddressResolveOutput>
        ) {
            do {
                try aggegator.append(
                    function: ENSContracts.ENSResolverFunctions.name(contract: query.resolverAddress, _node: query.nameHash),
                    response: ENSContracts.ENSRegistryResponses.AddressResolverResponse.self
                ) { result in
                    switch result {
                    case .success(let name):
                        registryOutput.intermediaryResponses[query.index] = AddressResolveOutput(
                            address: address,
                            output: .resolved(name)
                        )
                    case .failure(let error):
                        registryOutput.intermediaryResponses[query.index] = AddressResolveOutput(
                            address: address,
                            output: Self.output(from: error)
                        )
                    }
                }
            } catch let error {
                registryOutput.intermediaryResponses[query.index] = AddressResolveOutput(
                    address: address,
                    output: Self.output(from: error)
                )
            }
        }

        private func resolveName(
            _ query: XinfinNameService.MultiResolver.ResolverQuery,
            ens: String,
            aggegator: inout Multicall.Aggregator,
            registryOutput: RegistryOutput<NameResolveOutput>
        ) {
            do {
                try aggegator.append(
                    function: ENSContracts.ENSResolverFunctions.addr(contract: query.resolverAddress, _node: query.nameHash),
                    response: ENSContracts.ENSRegistryResponses.NameResolverResponse.self
                ) { result in
                    switch result {
                    case .success(let address):
                        registryOutput.intermediaryResponses[query.index] = NameResolveOutput(
                            ens: ens,
                            output: .resolved(address)
                        )
                    case .failure(let error):
                        registryOutput.intermediaryResponses[query.index] = NameResolveOutput(
                            ens: ens,
                            output: Self.output(from: error)
                        )
                    }
                }
            } catch let error {
                registryOutput.intermediaryResponses[query.index] = NameResolveOutput(
                    ens: ens,
                    output: Self.output(from: error)
                )
            }
        }

        private static func output<Value: Equatable>(from error: Error) -> ResolveOutput<Value> {
            guard let error = error as? Multicall.CallError
            else { return .couldNotBeResolved(.invalidInput) }

            switch error {
            case .contractFailure:
                return .couldNotBeResolved(.invalidInput)
            case .couldNotDecodeResponse(let error):
                if let specificError = error as? XinfinNameServiceError {
                    return .couldNotBeResolved(specificError)
                } else {
                    return .couldNotBeResolved(.invalidInput)
                }
            }
        }
    }
}
