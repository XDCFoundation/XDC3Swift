//
//  XDCKeyStorage.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation

public protocol XDCKeyStorageProtocol {
    func storePrivateKey(key: Data) throws -> Void
    func loadPrivateKey() throws -> Data
}

public enum XDCKeyStorageError: Error {
    case notFound
    case failedToSave
    case failedToLoad
}

public class XDCKeyLocalStorage: XDCKeyStorageProtocol {
    public init() {}
    
    private var localPath: String? {
        if let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            return url.appendingPathComponent("XDCKey").path
        }
        return nil
    }
    
    public func storePrivateKey(key: Data) throws -> Void {
        guard let localPath = self.localPath else {
            throw XDCKeyStorageError.failedToSave
        }
        
        let success = NSKeyedArchiver.archiveRootObject(key, toFile: localPath)
        
        if !success {
            throw XDCKeyStorageError.failedToSave
        }
    }
    
    public func loadPrivateKey() throws -> Data {
        guard let localPath = self.localPath else {
            throw XDCKeyStorageError.failedToLoad
        }
        
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: localPath) as? Data else {
            throw XDCKeyStorageError.failedToLoad
        }

        return data
    }
}
