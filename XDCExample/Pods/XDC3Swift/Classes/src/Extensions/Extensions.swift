//
//  Extensions.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation
import BigInt

public protocol XDC3Extendable {
    associatedtype T
    var xdc3: T { get }
}

public extension XDC3Extendable {
    var xdc3: XDC3Extensions<Self> {
        return XDC3Extensions(self)
    }
}

public struct XDC3Extensions<Base> {
    internal(set) public var base: Base
    init(_ base: Base) {
        self.base = base
    }
}

extension Data: XDC3Extendable {}
extension String: XDC3Extendable {}
extension BigUInt : XDC3Extendable {}
extension BigInt : XDC3Extendable {}
extension Int : XDC3Extendable {}
