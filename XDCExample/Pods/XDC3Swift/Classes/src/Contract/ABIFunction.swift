//
//  ABIFunction.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation
import BigInt

public protocol ABIFunction {
    static var name: String { get }
    var gasPrice: BigUInt? { get }
    var gasLimit: BigUInt? { get }
    var contract: XDCAddress { get }
    var from: XDCAddress? { get }
    func encode(to encoder: ABIFunctionEncoder) throws
}

public protocol ABIResponse: ABITupleDecodable {}

extension ABIFunction {
    public func transaction(gasPrice: BigUInt? = nil, gasLimit: BigUInt? = nil) throws -> XDCTransaction {
        let encoder = ABIFunctionEncoder(Self.name)
        try self.encode(to: encoder)
        let data = try encoder.encoded()
        
        return XDCTransaction(from: from, to: contract, data: data, gasPrice: self.gasPrice ?? gasPrice ?? BigUInt(0), gasLimit: self.gasLimit ?? gasLimit ?? BigUInt(0))
    }
}
