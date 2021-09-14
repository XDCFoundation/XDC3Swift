//
//  XRC20.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation
import BigInt

public class XRC20 {
    let client: XDCClient
    /**
     Initializer of XRC20 class
     */
    public init(client: XDCClient) {
        self.client = client
        
    }
    /**
     Returns the name of the token - e.g. "XDC_Demo".
     @params tokenAddress
     */
    public func name(tokenContract: XDCAddress,
                     completion: @escaping((Error?, String?) -> Void)) {
        let function = XRC20Functions.name(contract: tokenContract)
        function.call(withClient: self.client, responseType: XRC20Responses.nameResponse.self) { (error, nameResponse) in
            return completion(error, nameResponse?.value)
        }
    }
    /**
     Returns the symbol of the token - e.g. "XDC".
     @params tokenAddress
     */
    public func symbol(tokenContract: XDCAddress,
                       completion: @escaping((Error?, String?) -> Void)) {
        let function = XRC20Functions.symbol(contract: tokenContract)
        function.call(withClient: self.client, responseType: XRC20Responses.symbolResponse.self) { (error, symbolResponse) in
            return completion(error, symbolResponse?.value)
        }
    }
    /**
     Returns the decimals of the token - e.g. "18".
     @params tokenAddress
     */
    public func decimals(tokenContract: XDCAddress,
                         completion: @escaping((Error?, UInt8?) -> Void)) {
        let function = XRC20Functions.decimals(contract: tokenContract)
        function.call(withClient: self.client, responseType: XRC20Responses.decimalsResponse.self) { (error, decimalsResponse) in
            return completion(error, decimalsResponse?.value)
        }
    }
    /**
     Returns the totalSupply of the token - e.g. "10000000".
     @params tokenAddress
     */
    public func totalSupply(contract: XDCAddress,
                            completion: @escaping((Error?, BigUInt?) -> Void)) {
        let function = XRC20Functions.totalSupply(contract: contract)
        function.call(withClient: client, responseType: XRC20Responses.numberResponse.self) { error, response in
            return completion(error, response?.value)
        }
    }
    /**
     Returns the token balance of with account address.
     @params tokenAddress
     @params accountAddress
     */
    public func balanceOf(tokenContract: XDCAddress,
                          account: XDCAddress,
                          completion: @escaping((Error?, BigUInt?) -> Void)) {
        let function = XRC20Functions.balanceOf(contract: tokenContract, account: account)
        function.call(withClient: self.client, responseType: XRC20Responses.balanceResponse.self) { (error, balanceResponse) in
            return completion(error, balanceResponse?.value)
        }
    }
    /**
     Returns the amount which spender is still allowed to withdraw from owner.
     @params tokenAddress
     @params ownerAddress
     @params spenderAddress
     */
    public func allowance(tokenContract: XDCAddress,
                          address: XDCAddress,
                          spender: XDCAddress,
                          completion: @escaping((Error?, BigUInt?) -> Void)) {
        let function = XRC20Functions.allowance(contract: tokenContract, owner: address, spender: spender)
        function.call(withClient: self.client, responseType: XRC20Responses.allowance.self) { (error, balanceResponse) in
            return completion(error, balanceResponse?.value)
        }
    }
    /**
     Increase the amount of tokens that an owner allowed to a spender.
     @params account
     @params tokenAddress
     @params ownerAddress
     @params spenderAddress
     @params value
     */
    public func increaseAllowance(account:XDCAccount ,tokenAddress: XDCAddress, owner: XDCAddress, spender: XDCAddress, value: BigUInt, completion: @escaping((Any?)->Void)){
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
    /**
     Decrease the amount of tokens that an owner allowed to a spender.
     @params account
     @params tokenAddress
     @params ownerAddress
     @params spenderAddress
     @params value
     */
    public func decreaseAllowance(account: XDCAccount,tokenAddress: XDCAddress, owner: XDCAddress, spender: XDCAddress, value: BigUInt, completion: @escaping((Any?)->Void)){
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
    
    
    
}
