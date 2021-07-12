//
//  XinfinAccount+Sign.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation

enum XinfinSignerError: Error {
    case emptyRawTransaction
    case unknownError
}

public extension XinfinAccount {
    
    func signRaw(_ transaction: XinfinTransaction) throws -> Data {
        let signed: SignedTransaction = try sign(transaction)
        guard let raw = signed.raw else {
            throw XinfinSignerError.unknownError
        }
        return raw
    }
    
    internal func sign(_ transaction: XinfinTransaction) throws -> SignedTransaction {
        
        guard let raw = transaction.raw else {
            throw XinfinSignerError.emptyRawTransaction
        }
        
        guard let signature = try? self.sign(data: raw) else {
            throw XinfinSignerError.unknownError
        }
        
        let r = signature.subdata(in: 0..<32)
        let s = signature.subdata(in: 32..<64)
        
        var v = Int(signature[64])
        if v < 37 {
            v += (transaction.chainId ?? -1) * 2 + 35
        }
        
        return SignedTransaction(transaction: transaction, v: v, r: r, s: s)
    }
}
