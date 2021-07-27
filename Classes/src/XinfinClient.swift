//
//  XinfinClient.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation
import BigInt

public protocol XinfinClientProtocol {
    init(url: URL, sessionConfig: URLSessionConfiguration)
    init(url: URL)
    var network: XinfinNetwork? { get }
    
    func net_version(completion: @escaping((XinfinClientError?, XinfinNetwork?) -> Void))
    func eth_gasPrice(completion: @escaping((XinfinClientError?, BigUInt?) -> Void))
    func eth_blockNumber(completion: @escaping((XinfinClientError?, Int?) -> Void))
    func eth_getBalance(address: XinfinAddress, block: XinfinBlock, completion: @escaping((XinfinClientError?, BigUInt?) -> Void))
    func eth_getCode(address: XinfinAddress, block: XinfinBlock, completion: @escaping((XinfinClientError?, String?) -> Void))
    func eth_estimateGas(_ transaction: XinfinTransaction, withAccount account: XinfinAccount, completion: @escaping((XinfinClientError?, BigUInt?) -> Void))
    func eth_sendRawTransaction(_ transaction: XinfinTransaction, withAccount account: XinfinAccount, completion: @escaping((XinfinClientError?, String?) -> Void))
    func eth_getTransactionCount(address: XinfinAddress, block: XinfinBlock, completion: @escaping((XinfinClientError?, Int?) -> Void))
    func eth_getTransaction(byHash txHash: String, completion: @escaping((XinfinClientError?, XinfinTransaction?) -> Void))
    func eth_getTransactionReceipt(txHash: String, completion: @escaping((XinfinClientError?, XinfinTransactionReceipt?) -> Void))
    func eth_call(_ transaction: XinfinTransaction, block: XinfinBlock, completion: @escaping((XinfinClientError?, String?) -> Void))
    func eth_getLogs(addresses: [XinfinAddress]?, topics: [String?]?, fromBlock: XinfinBlock, toBlock: XinfinBlock, completion: @escaping((XinfinClientError?, [XinfinLog]?) -> Void))
    func eth_getLogs(addresses: [XinfinAddress]?, orTopics: [[String]?]?, fromBlock: XinfinBlock, toBlock: XinfinBlock, completion: @escaping((XinfinClientError?, [XinfinLog]?) -> Void))
    func eth_getBlockByNumber(_ block: XinfinBlock, completion: @escaping((XinfinClientError?, XinfinBlockInfo?) -> Void))
}

public enum XinfinClientError: Error {
    case tooManyResults
    case executionError
    case unexpectedReturnValue
    case noResultFound
    case decodeIssue
    case encodeIssue
    case noInputData
}

public class XinfinClient: XinfinClientProtocol {
    public let url: URL
    private var retreivedNetwork: XinfinNetwork?
    
    private let networkQueue: OperationQueue
    private let concurrentQueue: OperationQueue
    
    public let session: URLSession
    
    public var network: XinfinNetwork? {
        if let _ = self.retreivedNetwork {
            return self.retreivedNetwork
        }
        
        let group = DispatchGroup()
        group.enter()
        
        var network: XinfinNetwork?
        self.net_version { (error, retreivedNetwork) in
            if let error = error {
                print("Client has no network: \(error.localizedDescription)")
            } else {
                network = retreivedNetwork
                self.retreivedNetwork = network
            }
            
            group.leave()
        }
        
        group.wait()
        return network
    }
    
    required public init(url: URL, sessionConfig: URLSessionConfiguration) {
        self.url = url
        let networkQueue = OperationQueue()
        networkQueue.name = "XDC.client.networkQueue"
        networkQueue.qualityOfService = .background
        networkQueue.maxConcurrentOperationCount = 4
        self.networkQueue = networkQueue
        
        let txQueue = OperationQueue()
        txQueue.name = "XDC.client.rawTxQueue"
        txQueue.qualityOfService = .background
        txQueue.maxConcurrentOperationCount = 1
        self.concurrentQueue = txQueue
        
        self.session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: networkQueue)
    }
    
    required public convenience init(url: URL) {
        self.init(url: url, sessionConfig: URLSession.shared.configuration)
    }
    
    deinit {
        self.session.invalidateAndCancel()
    }
    
    public func net_version(completion: @escaping ((XinfinClientError?, XinfinNetwork?) -> Void)) {
        let emptyParams: Array<Bool> = []
        XinfinRPC.execute(session: session, url: url, method: "net_version", params: emptyParams, receive: String.self) { (error, response) in
            if let resString = response as? String {
                let network = XinfinNetwork.fromString(resString)
                completion(nil, network)
            } else {
                completion(XinfinClientError.unexpectedReturnValue, nil)
            }
        }
    }
    
    public func eth_gasPrice(completion: @escaping ((XinfinClientError?, BigUInt?) -> Void)) {
        let emptyParams: Array<Bool> = []
        XinfinRPC.execute(session: session, url: url, method: "eth_gasPrice", params: emptyParams, receive: String.self) { (error, response) in
            if let hexString = response as? String {
                completion(nil, BigUInt(hex: hexString))
            } else {
                completion(XinfinClientError.unexpectedReturnValue, nil)
            }
        }
    }
    
    public func eth_blockNumber(completion: @escaping ((XinfinClientError?, Int?) -> Void)) {
        let emptyParams: Array<Bool> = []
        XinfinRPC.execute(session: session, url: url, method: "eth_blockNumber", params: emptyParams, receive: String.self) { (error, response) in
            if let hexString = response as? String {
                if let integerValue = Int(hex: hexString) {
                    completion(nil, integerValue)
                } else {
                    completion(XinfinClientError.decodeIssue, nil)
                }
            } else {
                completion(XinfinClientError.unexpectedReturnValue, nil)
            }
        }
    }
    
    public func eth_getBalance(address: XinfinAddress, block: XinfinBlock, completion: @escaping ((XinfinClientError?, BigUInt?) -> Void)) {
        XinfinRPC.execute(session: session, url: url, method: "eth_getBalance", params: [address.value, block.stringValue], receive: String.self) { (error, response) in
            if let resString = response as? String, let balanceInt = BigUInt(hex: resString.web3.noHexPrefix) {
                completion(nil, balanceInt)
            } else {
                completion(XinfinClientError.unexpectedReturnValue, nil)
            }
        }
    }
    
    public func eth_getCode(address: XinfinAddress, block: XinfinBlock = .Latest, completion: @escaping((XinfinClientError?, String?) -> Void)) {
        XinfinRPC.execute(session: session, url: url, method: "eth_getCode", params: [address.value, block.stringValue], receive: String.self) { (error, response) in
            if let resDataString = response as? String {
                completion(nil, resDataString)
            } else {
                completion(XinfinClientError.unexpectedReturnValue, nil)
            }
        }
    }
    
    public func eth_estimateGas(_ transaction: XinfinTransaction, withAccount account: XinfinAccount, completion: @escaping((XinfinClientError?, BigUInt?) -> Void)) {
        
        struct CallParams: Encodable {
            let from: String?
            let to: String
            let gas: String?
            let gasPrice: String?
            let value: String?
            let data: String?
            
            enum TransactionCodingKeys: String, CodingKey {
                case from
                case to
                case gas
                case gasPrice
                case value
                case data
            }
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.unkeyedContainer()
                var nested = container.nestedContainer(keyedBy: TransactionCodingKeys.self)
                if let from = from {
                    try nested.encode(from, forKey: .from)
                }
                try nested.encode(to, forKey: .to)
                
                let jsonRPCAmount: (String) -> String = { amount in
                    amount == "0x00" ? "0x0" : amount
                }
                
                if let gas = gas.map(jsonRPCAmount) {
                    try nested.encode(gas, forKey: .gas)
                }
                if let gasPrice = gasPrice.map(jsonRPCAmount) {
                    try nested.encode(gasPrice, forKey: .gasPrice)
                }
                if let value = value.map(jsonRPCAmount) {
                    try nested.encode(value, forKey: .value)
                }
                if let data = data {
                    try nested.encode(data, forKey: .data)
                }
            }
        }
        
        let value: BigUInt?
        if let txValue = transaction.value, txValue > .zero {
            value = txValue
        } else {
            value = nil
        }
        
        let params = CallParams(from: transaction.from?.value,
                                to: transaction.to.value,
                                gas: transaction.gasLimit?.web3.hexString,
                                gasPrice: transaction.gasPrice?.web3.hexString,
                                value: value?.web3.hexString,
                                data: transaction.data?.web3.hexString)
        XinfinRPC.execute(session: session, url: url, method: "eth_estimateGas", params: params, receive: String.self) { (error, response) in
            if let gasHex = response as? String, let gas = BigUInt(hex: gasHex) {
                completion(nil, gas)
            } else if let error = error as? JSONRPCError, error.isExecutionError {
                completion(XinfinClientError.executionError, nil)
            } else {
                completion(XinfinClientError.unexpectedReturnValue, nil)
            }
        }
    }
    
    public func eth_sendRawTransaction(_ transaction: XinfinTransaction, withAccount account: XinfinAccount, completion: @escaping ((XinfinClientError?, String?) -> Void)) {
        
        concurrentQueue.addOperation {
            let group = DispatchGroup()
            group.enter()
            print("---->\(account.address)")
            // Inject latest nonce
            self.eth_getTransactionCount(address: account.address, block: .Latest) { (error, count) in
                guard let nonce = count else {
                   
                    group.leave()
                    return completion(XinfinClientError.unexpectedReturnValue, nil)
                }
                print("-->\(nonce)")
                var transaction = transaction
                transaction.nonce = nonce
                
                if transaction.chainId == nil, let network = self.network {
                    transaction.chainId = network.intValue
                }
                print(transaction)
                guard let _ = transaction.chainId, let signedTx = (try? account.sign(transaction)), let transactionHex = signedTx.raw?.web3.hexString else {
                    group.leave()
                    return completion(XinfinClientError.encodeIssue, nil)
                }
                print(transactionHex)
                XinfinRPC.execute(session: self.session, url: self.url, method: "eth_sendRawTransaction", params: [transactionHex], receive: String.self) { (error, response) in
                    group.leave()
                    if let resDataString = response as? String {
                        completion(nil, resDataString)
                    } else {
                        completion(XinfinClientError.unexpectedReturnValue, nil)
                    }
                }
                
            }
            group.wait()
        }
    }
    
    public func eth_getTransactionCount(address: XinfinAddress, block: XinfinBlock, completion: @escaping ((XinfinClientError?, Int?) -> Void)) {
        XinfinRPC.execute(session: session, url: url, method: "eth_getTransactionCount", params: [address.value, block.stringValue], receive: String.self) { (error, response) in
            if let resString = response as? String {
                let count = Int(hex: resString)
                completion(nil, count)
            } else {
                completion(XinfinClientError.unexpectedReturnValue, nil)
            }
        }
    }
    
    public func eth_getTransactionReceipt(txHash: String, completion: @escaping ((XinfinClientError?, XinfinTransactionReceipt?) -> Void)) {
        XinfinRPC.execute(session: session, url: url, method: "eth_getTransactionReceipt", params: [txHash], receive: XinfinTransactionReceipt.self) { (error, response) in
            if let receipt = response as? XinfinTransactionReceipt {
                completion(nil, receipt)
            } else if let _ = response {
                completion(XinfinClientError.noResultFound, nil)
            } else {
                completion(XinfinClientError.unexpectedReturnValue, nil)
            }
        }
    }
    
    public func eth_getTransaction(byHash txHash: String, completion: @escaping((XinfinClientError?, XinfinTransaction?) -> Void)) {
        
        XinfinRPC.execute(session: session, url: url, method: "eth_getTransactionByHash", params: [txHash], receive: XinfinTransaction.self) { (error, response) in
            if let transaction = response as? XinfinTransaction {
                completion(nil, transaction)
            } else {
                completion(XinfinClientError.unexpectedReturnValue, nil)
            }
        }
    }
    
    public func eth_call(_ transaction: XinfinTransaction, block: XinfinBlock = .Latest, completion: @escaping ((XinfinClientError?, String?) -> Void)) {
        guard let transactionData = transaction.data else {
            return completion(XinfinClientError.noInputData, nil)
        }
        
        struct CallParams: Encodable {
            let from: String?
            let to: String
            let data: String
            let block: String
            
            enum TransactionCodingKeys: String, CodingKey {
                case from
                case to
                case data
            }
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.unkeyedContainer()
                var nested = container.nestedContainer(keyedBy: TransactionCodingKeys.self)
                if let from = from {
                    try nested.encode(from, forKey: .from)
                }
                try nested.encode(to, forKey: .to)
                try nested.encode(data, forKey: .data)
                try container.encode(block)
            }
        }
        
        let params = CallParams(from: transaction.from?.value, to: transaction.to.value, data: transactionData.web3.hexString, block: block.stringValue)
        XinfinRPC.execute(session: session, url: url, method: "eth_call", params: params, receive: String.self) { (error, response) in
            if let resDataString = response as? String {
                completion(nil, resDataString)
            } else if
                let error = error,
                case let JSONRPCError.executionError(result) = error,
                (result.error.code == JSONRPCErrorCode.invalidInput || result.error.code == JSONRPCErrorCode.contractExecution) {
                completion(nil, "0x")
            } else {
                completion(XinfinClientError.unexpectedReturnValue, nil)
            }
        }
    }
    
    public func eth_getLogs(addresses: [XinfinAddress]?, topics: [String?]?, fromBlock from: XinfinBlock = .Earliest, toBlock to: XinfinBlock = .Latest, completion: @escaping ((XinfinClientError?, [XinfinLog]?) -> Void)) {
        eth_getLogs(addresses: addresses, topics: topics.map(Topics.plain), fromBlock: from, toBlock: to, completion: completion)
    }
    
    public func eth_getLogs(addresses: [XinfinAddress]?, orTopics topics: [[String]?]?, fromBlock from: XinfinBlock = .Earliest, toBlock to: XinfinBlock = .Latest, completion: @escaping((XinfinClientError?, [XinfinLog]?) -> Void)) {
        eth_getLogs(addresses: addresses, topics: topics.map(Topics.composed), fromBlock: from, toBlock: to, completion: completion)
    }

    private func eth_getLogs(addresses: [XinfinAddress]?, topics: Topics?, fromBlock from: XinfinBlock, toBlock to: XinfinBlock, completion: @escaping((XinfinClientError?, [XinfinLog]?) -> Void)) {
        DispatchQueue.global(qos: .default)
            .async {
                let result = RecursiveLogCollector(ethClient: self)
                    .getAllLogs(addresses: addresses, topics: topics, from: from, to: to)

                switch result {
                case .success(let logs):
                    completion(nil, logs)
                case .failure(let error):
                    completion(error, nil)
                }
            }
    }

    internal func getLogs(addresses: [XinfinAddress]?, topics: Topics?, fromBlock: XinfinBlock, toBlock: XinfinBlock, completion: @escaping((Result<[XinfinLog], XinfinClientError>) -> Void)) {

        struct CallParams: Encodable {
            var fromBlock: String
            var toBlock: String
            let address: [XinfinAddress]?
            let topics: Topics?
        }

        let params = CallParams(fromBlock: fromBlock.stringValue, toBlock: toBlock.stringValue, address: addresses, topics: topics)

        XinfinRPC.execute(session: session, url: url, method: "eth_getLogs", params: [params], receive: [XinfinLog].self) { (error, response) in
            if let logs = response as? [XinfinLog] {
                completion(.success(logs))
            } else {
                if let error = error as? JSONRPCError,
                   case let .executionError(innerError) = error,
                   innerError.error.code == JSONRPCErrorCode.tooManyResults {
                    completion(.failure(.tooManyResults))
                } else {
                    completion(.failure(.unexpectedReturnValue))
                }
            }
        }
    }

    public func eth_getBlockByNumber(_ block: XinfinBlock, completion: @escaping((XinfinClientError?, XinfinBlockInfo?) -> Void)) {
        
        struct CallParams: Encodable {
            let block: XinfinBlock
            let fullTransactions: Bool
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.unkeyedContainer()
                try container.encode(block.stringValue)
                try container.encode(fullTransactions)
            }
        }
        
        let params = CallParams(block: block, fullTransactions: false)
        
        XinfinRPC.execute(session: session, url: url, method: "eth_getBlockByNumber", params: params, receive: XinfinBlockInfo.self) { (error, response) in
            if let blockData = response as? XinfinBlockInfo {
                completion(nil, blockData)
            } else {
                completion(XinfinClientError.unexpectedReturnValue, nil)
            }
        }
    }
}

