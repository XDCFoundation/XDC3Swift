//
//  HexExtensions.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation
import BigInt

public extension BigUInt {
    init?(hex: String) {
        self.init(hex.xdc3.noHexPrefix.lowercased(), radix: 16)
    }
}

public extension XDC3Extensions where Base == BigUInt {
    var hexString: String {
        return String(bytes: base.xdc3.bytes)
    }
}

public extension BigInt {
    init?(hex: String) {
        self.init(hex.xdc3.noHexPrefix.lowercased(), radix: 16)
    }
}

public extension Int {
    init?(hex: String) {
        self.init(hex.xdc3.noHexPrefix, radix: 16)
    }
}

public extension XDC3Extensions where Base == Int {
    var hexString: String {
        return "0x" + String(format: "%x", base)
    }
}

public extension Data {
    init?(hex: String) {
        if let byteArray = try? HexUtil.byteArray(fromHex: hex.xdc3.noHexPrefix) {
            self.init(bytes: byteArray, count: byteArray.count)
        } else {
            return nil
        }
    }
}

public extension XDC3Extensions where Base == Data {
    var hexString: String {
        let bytes = Array<UInt8>(base)
        return "0x" + bytes.map { String(format: "%02hhx", $0) }.joined()
    }
    var xdcString: String{
        let bytes = Array<UInt8>(base)
        return "xdc" + bytes.map { String(format: "%02hhx", $0) }.joined()
    }
}

public extension String {
    init(bytes: [UInt8]) {
        self.init("0x" + bytes.map { String(format: "%02hhx", $0) }.joined())
    }
}

public extension XDC3Extensions where Base == String {
    var noHexPrefix: String {
        if base.hasPrefix("0x") {
            let index = base.index(base.startIndex, offsetBy: 2)
            return String(base[index...])
        }
        return base
    }
    var noxdcPrefix: String {
        if base.hasPrefix("xdc") {
            let index = base.index(base.startIndex, offsetBy: 3)
            return String(base[index...])
        }
        return base
    }
    
    var withHexPrefix: String {
        if !base.hasPrefix("0x") {
            return "0x" + base
        }
        return base
    }
    
    var withXdcPrefix: String{
        if !base.hasPrefix("xdc") {
            return "xdc" + base
        }
        return base
    }
    
    var stringValue: String {
        if let byteArray = try? HexUtil.byteArray(fromHex: base.xdc3.noHexPrefix), let str = String(bytes: byteArray, encoding: .utf8) {
            return str
        }
        
        return base
    }
    
    var hexData: Data? {
        let noHexPrefix = self.noHexPrefix
        if let bytes = try? HexUtil.byteArray(fromHex: noHexPrefix) {
            return Data( bytes)
        }
        
        return nil
    }
    var xdcData:Data? {
        let noXdcPrefix = self.noxdcPrefix
        if let bytes = try? HexUtil.byteArray(fromHex: noXdcPrefix) {
            return Data( bytes)
        }
        
        return nil
    }
    
}
