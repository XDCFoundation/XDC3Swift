//
//  XDCAccount.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation

protocol XDCAccountProtocol {
    var address: XDCAddress { get }
    
    // For Keystore handling
    init?(keyStorage: XDCKeyStorageProtocol, keystorePassword: String) throws
    static func create(keyStorage: XDCKeyStorageProtocol, keystorePassword password: String) throws -> XDCAccount
    
    // For non-Keystore formats. This is not recommended, however some apps may wish to implement their own storage.
    init(keyStorage: XDCKeyStorageProtocol) throws
    
    func sign(data: Data) throws -> Data
    func sign(hash: String) throws -> Data
    func sign(hex: String) throws -> Data
    func sign(message: Data) throws -> Data
    func sign(message: String) throws -> Data
    func sign(_ transaction: XDCTransaction) throws -> SignedTransaction
}

public enum XDCAccountError: Error {
    case createAccountError
    case loadAccountError
    case signError
}

public class XDCAccount: XDCAccountProtocol {
    private let privateKeyData: Data
    private let publicKeyData: Data
    
    public lazy var publicKey: String = {
        return self.publicKeyData.xdc3.hexString
    }()
    public lazy var privateKey: String = {
        return self.privateKeyData.xdc3.hexString
    }()
    
    public lazy var address: XDCAddress = {
        return KeyUtil.generateAddress(from: self.publicKeyData)
    }()
    
    required public init(keyStorage: XDCKeyStorageProtocol, keystorePassword password: String) throws {
        
        do {
            let data = try keyStorage.loadPrivateKey()
            if let decodedKey = try? KeystoreUtil.decode(data: data, password: password) {
                self.privateKeyData = decodedKey
                self.publicKeyData = try KeyUtil.generatePublicKey(from: decodedKey)
            } else {
                print("Error decrypting key data")
                throw XDCAccountError.loadAccountError
            }
        } catch {
           throw XDCAccountError.loadAccountError
        }
    }
    
    required public init(keyStorage: XDCKeyStorageProtocol) throws {
        do {
            let data = try keyStorage.loadPrivateKey()
            self.privateKeyData = data
            self.publicKeyData = try KeyUtil.generatePublicKey(from: data)
        } catch {
            throw XDCAccountError.loadAccountError
        }
    }
    
    //   Create a account with private and public key.
     
    public static func create(keyStorage: XDCKeyStorageProtocol, keystorePassword password: String) throws -> XDCAccount {
        guard let privateKey = KeyUtil.generatePrivateKeyData() else {
            throw XDCAccountError.createAccountError
        }
        
        do {
            let encodedData = try KeystoreUtil.encode(privateKey: privateKey, password: password)
            try keyStorage.storePrivateKey(key: encodedData)
            return try self.init(keyStorage: keyStorage, keystorePassword: password)
        } catch {
            throw XDCAccountError.createAccountError
        }
    }
    
    public func sign(data: Data) throws -> Data {
        return try KeyUtil.sign(message: data, with: self.privateKeyData, hashing: true)
    }
    
    public func sign(hex: String) throws -> Data {
        if let data = Data.init(hex: hex) {
            return try KeyUtil.sign(message: data, with: self.privateKeyData, hashing: true)
        } else {
            throw XDCAccountError.signError
        }
    }
    
    public func sign(hash: String) throws -> Data {
        if let data = hash.xdc3.hexData {
            return try KeyUtil.sign(message: data, with: self.privateKeyData, hashing: false)
        } else {
            throw XDCAccountError.signError
        }
    }
    
    public func sign(message: Data) throws -> Data {
        return try KeyUtil.sign(message: message, with: self.privateKeyData, hashing: false)
    }
    
    public func sign(message: String) throws -> Data {
        if let data = message.data(using: .utf8) {
            return try KeyUtil.sign(message: data, with: self.privateKeyData, hashing: true)
        } else {
            throw XDCAccountError.signError
        }
    }
    
    public func signMessage(message: Data) throws -> String {
        let prefix = "\u{19}XDC Signed Message:\n\(String(message.count))"
        guard var data = prefix.data(using: .ascii) else {
            throw XDCAccountError.signError
        }
        data.append(message)
        let hash = data.xdc3.keccak256
        
        guard var signed = try? self.sign(message: hash) else {
            throw XDCAccountError.signError
            
        }
        
        // Check last char (v)
        guard var last = signed.popLast() else {
            throw XDCAccountError.signError
            
        }
        
        if last < 27 {
            last += 27
        }
        
        signed.append(last)
        return signed.xdc3.hexString
    }
    
    public func signMessage(message: TypedData) throws -> String {
        let hash = try message.signableHash()
        
        guard var signed = try? self.sign(message: hash) else {
            throw XDCAccountError.signError
            
        }
        
        // Check last char (v)
        guard var last = signed.popLast() else {
            throw XDCAccountError.signError
            
        }
        
        if last < 27 {
            last += 27
        }
        
        signed.append(last)
        return signed.xdc3.hexString
    }
}
