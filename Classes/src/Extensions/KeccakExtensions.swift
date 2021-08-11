//
//  KeccakExtensions.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation
import keccaktiny

public extension XDC3Extensions where Base == Data {
    var keccak256: Data {
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 32)
        defer {
            result.deallocate()
        }
        let nsData = base as NSData
        let input = nsData.bytes.bindMemory(to: UInt8.self, capacity: base.count)
        keccak_256(result, 32, input, base.count)
        return Data(bytes: result, count: 32)
    }
}

public extension XDC3Extensions where Base == String {
    var keccak256: Data {
        let data = base.data(using: .utf8) ?? Data()
        return data.xdc3.keccak256
    }
    
    var keccak256fromHex: Data {
        let data = base.xdc3.hexData!
        return data.xdc3.keccak256
    }
    
    var keccak256fromXDC: Data {
        let data = base.xdc3.xdcData!
        return data.xdc3.keccak256
    }
    
}
