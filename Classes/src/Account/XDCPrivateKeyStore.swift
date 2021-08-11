//
//  XDCPrivateKeyStore.swift
//  XDC
//
//  Created by Developer on 29/06/21.
//

import Foundation
import BigInt
/**
   It will store and load private key and help in fetching information regarding private key.
 */
public class XDCPrivateKeyStore : XDCKeyStorageProtocol {
    private var privateKey: String
    
   public init(privateKey: String) {
        self.privateKey = privateKey
    }
    
    public func storePrivateKey(key: Data) throws -> Void {
    }
    
    public func loadPrivateKey() throws -> Data {
        return privateKey.xdc3.hexData!
    }
}
