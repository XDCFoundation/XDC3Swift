//
//  XinfinKeyStorage.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation

public protocol XinfinKeyStorageProtocol {
    func storePrivateKey(key: Data) throws -> Void
    func loadPrivateKey() throws -> Data
}

public enum XinfinKeyStorageError: Error {
    case notFound
    case failedToSave
    case failedToLoad
}

public class XinfinKeyLocalStorage: XinfinKeyStorageProtocol {
    public init() {}
    
    private var localPath: String? {
        if let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            return url.appendingPathComponent("XinfinKey").path
        }
        return nil
    }
    
    public func storePrivateKey(key: Data) throws -> Void {
        guard let localPath = self.localPath else {
            throw XinfinKeyStorageError.failedToSave
        }
        
        let success = NSKeyedArchiver.archiveRootObject(key, toFile: localPath)
        
        if !success {
            throw XinfinKeyStorageError.failedToSave
        }
    }
    
    public func loadPrivateKey() throws -> Data {
        guard let localPath = self.localPath else {
            throw XinfinKeyStorageError.failedToLoad
        }
        
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: localPath) as? Data else {
            throw XinfinKeyStorageError.failedToLoad
        }

        return data
    }
}
