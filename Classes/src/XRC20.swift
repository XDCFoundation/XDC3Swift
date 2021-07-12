//
//  XRC20.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation
import BigInt
struct Root: Codable{
  fileprivate let result: [Result]
}

private struct Result: Codable {
    let id, hash: String
    let v, blockNumber: Int
  //  let contract: Contract
    let from: String
   // let method: Method
    let timestamp: Int
    let to, value: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case hash
        case v = "__v"
        case blockNumber, from, timestamp, to, value
    }
}
public class XRC20 {
    let client: XinfinClient

    var url = URL(string: "https://explorer.apothem.network/publicAPI")
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
    
    public func approve(tokenContract: XinfinAddress,
                        spender: XinfinAddress,
                        value: BigUInt,
                        completion: @escaping((Error?, BigUInt?) -> Void)){
        let function = XRC20Functions.approve(contract: tokenContract, spender: spender, value: value)
        function.call(withClient: self.client, responseType: XRC20Responses.approve.self) { (error, approve) in
            return completion(error,approve?.value)
        }
        
    }
    
    public func transferP(tokenContract: XinfinAddress,
                        to: XinfinAddress,
                        value: BigUInt,
                        completion: @escaping((Error?, BigUInt?) -> Void)){
        let function = XRC20Functions.transfer(contract: tokenContract, to: to, value: value)
        function.call(withClient: self.client, responseType: XRC20Responses.transfer.self) { (error, approve) in
            return completion(error,approve?.value)
        }
        
    }
    
    
    public func transferFrom(tokenContract: XinfinAddress,
                             sender: XinfinAddress,
                        to: XinfinAddress,
                        value: BigUInt,
                        completion: @escaping((Error?, BigUInt?) -> Void)){
        let function = XRC20Functions.transferFrom(contract: tokenContract, sender: sender, to: to, value: value)
        function.call(withClient: self.client, responseType: XRC20Responses.transferFrom.self) { (error, approve) in
            return completion(error,approve?.value)
        }
        
    }
    
    public func increaseAllowance(tokenContract: XinfinAddress,
                             sender: XinfinAddress,
                        value: BigUInt,
                        completion: @escaping((Error?, BigUInt?) -> Void)){
        let function = XRC20Functions.increaseAllowance(contract: tokenContract, sender: sender, value: value)
        function.call(withClient: self.client, responseType: XRC20Responses.increaseAllowance.self) { (error, approve) in
            return completion(error,approve?.value)
        }
        
    }
    
    public func decreaseAllowance(tokenContract: XinfinAddress,
                             sender: XinfinAddress,
                        value: BigUInt,
                        completion: @escaping((Error?, BigUInt?) -> Void)){
        let function = XRC20Functions.decreaseAllowance(contract: tokenContract, sender: sender, value: value)
        function.call(withClient: self.client, responseType: XRC20Responses.decreaseAllowance.self) { (error, approve) in
            return completion(error,approve?.value)
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
    
    public func transfer(tokenContract: String,
                          completion: @escaping ((Error?,Int?) -> Void)){
        
        url?.appendQueryItem(name: "action", value: "tokentransfers")
        url?.appendQueryItem(name: "contractaddress", value:tokenContract)
    
    
       // print(url!)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
        if error != nil{
            print(error!)
        }
        
        do{
            let s = try JSONDecoder().decode(Root.self, from: data!)
       //     print(s.result.count)
            return completion(nil,s.result.count)
        }catch{
            print("error")
        }
           
   }.resume()
        
        
}
}
extension URL {

    mutating func appendQueryItem(name: String, value: String?) {

        guard var urlComponents = URLComponents(string: absoluteString) else { return }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: name, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        self = urlComponents.url!
    }
}
