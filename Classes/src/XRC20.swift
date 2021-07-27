//
//  XRC20.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation
import BigInt

public class XRC20 {
    let client: XinfinClient
   // var account: XinfinAccount?
    public init(client: XinfinClient) {
        self.client = client
        
    }
    
    public func name(tokenContract: XinfinAddress,
                     completion: @escaping((Error?, String?) -> Void)) {
        let function = XRC20Functions.name(contract: tokenContract)
        function.call(withClient: self.client, responseType: XRC20Responses.nameResponse.self) { (error, nameResponse) in
            return completion(error, nameResponse?.value)
        }
    }
    
    public func symbol(tokenContract: XinfinAddress,
                       completion: @escaping((Error?, String?) -> Void)) {
        let function = XRC20Functions.symbol(contract: tokenContract)
        function.call(withClient: self.client, responseType: XRC20Responses.symbolResponse.self) { (error, symbolResponse) in
            return completion(error, symbolResponse?.value)
        }
    }
    
    public func decimals(tokenContract: XinfinAddress,
                         completion: @escaping((Error?, UInt8?) -> Void)) {
        let function = XRC20Functions.decimals(contract: tokenContract)
        function.call(withClient: self.client, responseType: XRC20Responses.decimalsResponse.self) { (error, decimalsResponse) in
            return completion(error, decimalsResponse?.value)
        }
    }
    
    public func totalSupply(contract: XinfinAddress,
                            completion: @escaping((Error?, BigUInt?) -> Void)) {
        let function = XRC20Functions.totalSupply(contract: contract)
        function.call(withClient: client, responseType: XRC20Responses.numberResponse.self) { error, response in
            return completion(error, response?.value)
        }
    }
    
    
    
    public func balanceOf(tokenContract: XinfinAddress,
                          account: XinfinAddress,
                          completion: @escaping((Error?, BigUInt?) -> Void)) {
        let function = XRC20Functions.balanceOf(contract: tokenContract, account: account)
        function.call(withClient: self.client, responseType: XRC20Responses.balanceResponse.self) { (error, balanceResponse) in
            return completion(error, balanceResponse?.value)
        }
    }
    
    public func allowance(tokenContract: XinfinAddress,
                          address: XinfinAddress,
                          spender: XinfinAddress,
                          completion: @escaping((Error?, BigUInt?) -> Void)) {
        let function = XRC20Functions.allowance(contract: tokenContract, owner: address, spender: spender)
        function.call(withClient: self.client, responseType: XRC20Responses.allowance.self) { (error, balanceResponse) in
            return completion(error, balanceResponse?.value)
        }
    }
    
    public func increaseAllowance(account:XinfinAccount ,tokenAddress: XinfinAddress, owner: XinfinAddress, spender: XinfinAddress, value: BigUInt, completion: @escaping((Any?)->Void)){
        var myVal = value

        allowance(tokenContract: tokenAddress, address: owner, spender: spender) { (error, allow) in
            myVal = allow! + myVal
            let function = XRC20Functions.approve(contract: tokenAddress, spender: spender, value: myVal)
            let transaction = try? function.transaction(gasPrice: 3500000, gasLimit: 3000000)
            self.client.eth_sendRawTransaction(transaction!, withAccount: account ) { (error, txHash) in
                return completion(txHash)
            }
            
        }
    }
    
    public func decreaseAllowance(account: XinfinAccount,tokenAddress: XinfinAddress, owner: XinfinAddress, spender: XinfinAddress, value: BigUInt, completion: @escaping((Any?)->Void)){
        var myVal = value

        allowance(tokenContract: tokenAddress, address: owner, spender: spender) { (error, allow) in
            if allow! > 0{
                myVal = allow! - myVal
            }
            
            let function = XRC20Functions.approve(contract: tokenAddress, spender: spender, value: myVal)
            let transaction = try? function.transaction(gasPrice: 3500000, gasLimit: 3000000)
            self.client.eth_sendRawTransaction(transaction!, withAccount: account ) { (error, txHash) in
                return completion(txHash)
            }
            
        }
    }
    public func transferEventsTo(recipient: XinfinAddress,
                                 fromBlock: XinfinBlock,
                                 toBlock: XinfinBlock,
                                 completion: @escaping((Error?, [XRC20Events.Transfer]?) -> Void)) {
        
        guard let result = try? ABIEncoder.encode(recipient).bytes, let sig = try? XRC20Events.Transfer.signature() else {
            completion(XinfinSignerError.unknownError, nil)
            return
        }
        
        self.client.getEvents(addresses: nil,
                              topics: [ sig, nil, String(hexFromBytes: result)],
                              fromBlock: fromBlock,
                              toBlock: toBlock,
                              eventTypes: [XRC20Events.Transfer.self]) { (error, events, unprocessedLogs) in
            
            if let events = events as? [XRC20Events.Transfer] {
                return completion(error, events)
            } else {
                return completion(error ?? XinfinClientError.decodeIssue, nil)
            }
            
        }
    }
    
    public func transferEventsFrom(sender: XinfinAddress,
                                   fromBlock: XinfinBlock,
                                   toBlock: XinfinBlock,
                                   completion: @escaping((Error?, [XRC20Events.Transfer]?) -> Void)) {
        
        guard let result = try? ABIEncoder.encode(sender).bytes, let sig = try? XRC20Events.Transfer.signature() else {
            completion(XinfinSignerError.unknownError, nil)
            return
        }
        
        self.client.getEvents(addresses: nil,
                              topics: [ sig, String(hexFromBytes: result), nil ],
                              fromBlock: fromBlock,
                              toBlock: toBlock,
                              eventTypes: [XRC20Events.Transfer.self]) { (error, events, unprocessedLogs) in
            
            if let events = events as? [XRC20Events.Transfer] {
                return completion(error, events)
            } else {
                return completion(error ?? XinfinClientError.decodeIssue, nil)
            }
            
        }
    }
    
   
        
}
