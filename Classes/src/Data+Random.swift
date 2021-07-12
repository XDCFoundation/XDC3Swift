//
//  Data+Random.swift
//  web3s
//
// Created by Developer on 15/06/21.
//

import Foundation

extension Data {
    static func randomOfLength(_ length: Int) -> Data? {
        var data = [UInt8](repeating: 0, count: length)
        let result = SecRandomCopyBytes(kSecRandomDefault,
                               data.count,
                               &data)
        if result == errSecSuccess {
            return Data(data)
        }
        
        return nil
    }
}
