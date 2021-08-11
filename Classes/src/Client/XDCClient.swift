//
//  XDCClient.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation
import BigInt

public protocol XDCClientProtocol {
    init(url: URL, sessionConfig: URLSessionConfiguration)
    init(url: URL)
    var network: XDCNetwork? { get }
    
    func net_version(completion: @escaping((XDCClientError?, XDCNetwork?) -> Void))
    func eth_gasPrice(completion: @escaping((XDCClientError?, BigUInt?) -> Void))
    func eth_blockNumber(completion: @escaping((XDCClientError?, Int?) -> Void))
    func eth_getBalance(address: XDCAddress, block: XDCBlock, completion: @escaping((XDCClientError?, BigUInt?) -> Void))
    func eth_getCode(address: XDCAddress, block: XDCBlock, completion: @escaping((XDCClientError?, String?) -> Void))
    func eth_estimateGas(_ transaction: XDCTransaction, withAccount account: XDCAccount, completion: @escaping((XDCClientError?, BigUInt?) -> Void))
    func eth_sendRawTransaction(_ transaction: XDCTransaction, withAccount account: XDCAccount, completion: @escaping((XDCClientError?, String?) -> Void))
    func eth_getTransactionCount(address: XDCAddress, block: XDCBlock, completion: @escaping((XDCClientError?, Int?) -> Void))
    func eth_getTransaction(byHash txHash: String, completion: @escaping((XDCClientError?, XDCTransaction?) -> Void))
    func eth_getTransactionReceipt(txHash: String, completion: @escaping((XDCClientError?, XDCTransactionReceipt?) -> Void))
    func eth_call(_ transaction: XDCTransaction, block: XDCBlock, completion: @escaping((XDCClientError?, String?) -> Void))
    func eth_getLogs(addresses: [XDCAddress]?, topics: [String?]?, fromBlock: XDCBlock, toBlock: XDCBlock, completion: @escaping((XDCClientError?, [XDCLog]?) -> Void))
    func eth_getLogs(addresses: [XDCAddress]?, orTopics: [[String]?]?, fromBlock: XDCBlock, toBlock: XDCBlock, completion: @escaping((XDCClientError?, [XDCLog]?) -> Void))
    func eth_getBlockByNumber(_ block: XDCBlock, completion: @escaping((XDCClientError?, XDCBlockInfo?) -> Void))
}

public enum XDCClientError: Error {
    case tooManyResults
    case executionError
    case unexpectedReturnValue
    case noResultFound
    case decodeIssue
    case encodeIssue
    case noInputData
}

public class XDCClient: XDCClientProtocol {
    public let url: URL
    private var retreivedNetwork: XDCNetwork?
    
    private let networkQueue: OperationQueue
    private let concurrentQueue: OperationQueue
    
    public let session: URLSession
    
    public var network: XDCNetwork? {
        if let _ = self.retreivedNetwork {
            return self.retreivedNetwork
        }
        
        let group = DispatchGroup()
        group.enter()
        
        var network: XDCNetwork?
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
    
    public func net_version(completion: @escaping ((XDCClientError?, XDCNetwork?) -> Void)) {
        let emptyParams: Array<Bool> = []
        XDCRPC.execute(session: session, url: url, method: "net_version", params: emptyParams, receive: String.self) { (error, response) in
            if let resString = response as? String {
                let network = XDCNetwork.fromString(resString)
                completion(nil, network)
            } else {
                completion(XDCClientError.unexpectedReturnValue, nil)
            }
        }
    }
    
    public func eth_gasPrice(completion: @escaping ((XDCClientError?, BigUInt?) -> Void)) {
        let emptyParams: Array<Bool> = []
        XDCRPC.execute(session: session, url: url, method: "eth_gasPrice", params: emptyParams, receive: String.self) { (error, response) in
            if let hexString = response as? String {
                completion(nil, BigUInt(hex: hexString))
            } else {
                completion(XDCClientError.unexpectedReturnValue, nil)
            }
        }
    }
    
    public func eth_blockNumber(completion: @escaping ((XDCClientError?, Int?) -> Void)) {
        let emptyParams: Array<Bool> = []
        XDCRPC.execute(session: session, url: url, method: "eth_blockNumber", params: emptyParams, receive: String.self) { (error, response) in
            if let hexString = response as? String {
                if let integerValue = Int(hex: hexString) {
                    completion(nil, integerValue)
                } else {
                    completion(XDCClientError.decodeIssue, nil)
                }
            } else {
                completion(XDCClientError.unexpectedReturnValue, nil)
            }
        }
    }
    
    public func eth_getBalance(address: XDCAddress, block: XDCBlock, completion: @escaping ((XDCClientError?, BigUInt?) -> Void)) {
        XDCRPC.execute(session: session, url: url, method: "eth_getBalance", params: [address.value, block.stringValue], receive: String.self) { (error, response) in
            if let resString = response as? String, let balanceInt = BigUInt(hex: resString.xdc3.noHexPrefix) {
                completion(nil, balanceInt)
            } else {
                completion(XDCClientError.unexpectedReturnValue, nil)
            }
        }
    }
    
    public func eth_getCode(address: XDCAddress, block: XDCBlock = .Latest, completion: @escaping((XDCClientError?, String?) -> Void)) {
        XDCRPC.execute(session: session, url: url, method: "eth_getCode", params: [address.value, block.stringValue], receive: String.self) { (error, response) in
            if let resDataString = response as? String {
                completion(nil, resDataString)
            } else {
                completion(XDCClientError.unexpectedReturnValue, nil)
            }
        }
    }
    
    public func eth_estimateGas(_ transaction: XDCTransaction, withAccount account: XDCAccount, completion: @escaping((XDCClientError?, BigUInt?) -> Void)) {
        
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
                                gas: transaction.gasLimit?.xdc3.hexString,
                                gasPrice: transaction.gasPrice?.xdc3.hexString,
                                value: value?.xdc3.hexString,
                                data: transaction.data?.xdc3.hexString)
        XDCRPC.execute(session: session, url: url, method: "eth_estimateGas", params: params, receive: String.self) { (error, response) in
            if let gasHex = response as? String, let gas = BigUInt(hex: gasHex) {
                completion(nil, gas)
            } else if let error = error as? JSONRPCError, error.isExecutionError {
                completion(XDCClientError.executionError, nil)
            } else {
                completion(XDCClientError.unexpectedReturnValue, nil)
            }
        }
    }
    
    public func eth_sendRawTransaction(_ transaction: XDCTransaction, withAccount account: XDCAccount, completion: @escaping ((XDCClientError?, String?) -> Void)) {
        
        concurrentQueue.addOperation {
            let group = DispatchGroup()
            group.enter()
            
            // Inject latest nonce
            self.eth_getTransactionCount(address: account.address, block: .Latest) { (error, count) in
                guard let nonce = count else {
                   
                    group.leave()
                    return completion(XDCClientError.unexpectedReturnValue, nil)
                }
                
                var transaction = transaction
                transaction.nonce = nonce
                
                if transaction.chainId == nil, let network = self.network {
                    transaction.chainId = network.intValue
                }
                
                guard let _ = transaction.chainId, let signedTx = (try? account.sign(transaction)), let transactionHex = signedTx.raw?.xdc3.hexString else {
                    group.leave()
                    return completion(XDCClientError.encodeIssue, nil)
                }
                
                XDCRPC.execute(session: self.session, url: self.url, method: "eth_sendRawTransaction", params: [transactionHex], receive: String.self) { (error, response) in
                    group.leave()
                    if let resDataString = response as? String {
                        completion(nil, resDataString)
                    } else {
                        completion(XDCClientError.unexpectedReturnValue, nil)
                    }
                }
                
            }
            group.wait()
        }
    }
    
    public func eth_getTransactionCount(address: XDCAddress, block: XDCBlock, completion: @escaping ((XDCClientError?, Int?) -> Void)) {
        XDCRPC.execute(session: session, url: url, method: "eth_getTransactionCount", params: [address.value, block.stringValue], receive: String.self) { (error, response) in
            if let resString = response as? String {
                let count = Int(hex: resString)
                completion(nil, count)
            } else {
                completion(XDCClientError.unexpectedReturnValue, nil)
            }
        }
    }
    
    public func eth_getTransactionReceipt(txHash: String, completion: @escaping ((XDCClientError?, XDCTransactionReceipt?) -> Void)) {
        XDCRPC.execute(session: session, url: url, method: "eth_getTransactionReceipt", params: [txHash], receive: XDCTransactionReceipt.self) { (error, response) in
            if let receipt = response as? XDCTransactionReceipt {
                completion(nil, receipt)
            } else if let _ = response {
                completion(XDCClientError.noResultFound, nil)
            } else {
                completion(XDCClientError.unexpectedReturnValue, nil)
            }
        }
    }
    
    public func eth_getTransaction(byHash txHash: String, completion: @escaping((XDCClientError?, XDCTransaction?) -> Void)) {
        
        XDCRPC.execute(session: session, url: url, method: "eth_getTransactionByHash", params: [txHash], receive: XDCTransaction.self) { (error, response) in
            if let transaction = response as? XDCTransaction {
                completion(nil, transaction)
            } else {
                completion(XDCClientError.unexpectedReturnValue, nil)
            }
        }
    }
    
    public func eth_call(_ transaction: XDCTransaction, block: XDCBlock = .Latest, completion: @escaping ((XDCClientError?, String?) -> Void)) {
        guard let transactionData = transaction.data else {
            return completion(XDCClientError.noInputData, nil)
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
        
        let params = CallParams(from: transaction.from?.value, to: transaction.to.value, data: transactionData.xdc3.hexString, block: block.stringValue)
        XDCRPC.execute(session: session, url: url, method: "eth_call", params: params, receive: String.self) { (error, response) in
            if let resDataString = response as? String {
                completion(nil, resDataString)
            } else if
                let error = error,
                case let JSONRPCError.executionError(result) = error,
                (result.error.code == JSONRPCErrorCode.invalidInput || result.error.code == JSONRPCErrorCode.contractExecution) {
                completion(nil, "0x")
            } else {
                completion(XDCClientError.unexpectedReturnValue, nil)
            }
        }
    }
    
    public func eth_getLogs(addresses: [XDCAddress]?, topics: [String?]?, fromBlock from: XDCBlock = .Earliest, toBlock to: XDCBlock = .Latest, completion: @escaping ((XDCClientError?, [XDCLog]?) -> Void)) {
        eth_getLogs(addresses: addresses, topics: topics.map(Topics.plain), fromBlock: from, toBlock: to, completion: completion)
    }
    
    public func eth_getLogs(addresses: [XDCAddress]?, orTopics topics: [[String]?]?, fromBlock from: XDCBlock = .Earliest, toBlock to: XDCBlock = .Latest, completion: @escaping((XDCClientError?, [XDCLog]?) -> Void)) {
        eth_getLogs(addresses: addresses, topics: topics.map(Topics.composed), fromBlock: from, toBlock: to, completion: completion)
    }

    private func eth_getLogs(addresses: [XDCAddress]?, topics: Topics?, fromBlock from: XDCBlock, toBlock to: XDCBlock, completion: @escaping((XDCClientError?, [XDCLog]?) -> Void)) {
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

    internal func getLogs(addresses: [XDCAddress]?, topics: Topics?, fromBlock: XDCBlock, toBlock: XDCBlock, completion: @escaping((Result<[XDCLog], XDCClientError>) -> Void)) {

        struct CallParams: Encodable {
            var fromBlock: String
            var toBlock: String
            let address: [XDCAddress]?
            let topics: Topics?
        }

        let params = CallParams(fromBlock: fromBlock.stringValue, toBlock: toBlock.stringValue, address: addresses, topics: topics)

        XDCRPC.execute(session: session, url: url, method: "eth_getLogs", params: [params], receive: [XDCLog].self) { (error, response) in
            if let logs = response as? [XDCLog] {
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

    public func eth_getBlockByNumber(_ block: XDCBlock, completion: @escaping((XDCClientError?, XDCBlockInfo?) -> Void)) {
        
        struct CallParams: Encodable {
            let block: XDCBlock
            let fullTransactions: Bool
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.unkeyedContainer()
                try container.encode(block.stringValue)
                try container.encode(fullTransactions)
            }
        }
        
        let params = CallParams(block: block, fullTransactions: false)
        
        XDCRPC.execute(session: session, url: url, method: "eth_getBlockByNumber", params: params, receive: XDCBlockInfo.self) { (error, response) in
            if let blockData = response as? XDCBlockInfo {
                completion(nil, blockData)
            } else {
                completion(XDCClientError.unexpectedReturnValue, nil)
            }
        }
    }
}

