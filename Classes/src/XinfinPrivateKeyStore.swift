//
//  XinfinPrivateKeyStore.swift
//  XDC
//
//  Created by Developer on 29/06/21.
//

import Foundation
import BigInt

public class XinfinPrivateKeyStore : XinfinKeyStorageProtocol {
    private var privateKey: String
    
   public init(privateKey: String) {
        self.privateKey = privateKey
    }
    
    public func storePrivateKey(key: Data) throws -> Void {
    }
    
    public func loadPrivateKey() throws -> Data {
        return privateKey.web3.hexData!
    }
}
