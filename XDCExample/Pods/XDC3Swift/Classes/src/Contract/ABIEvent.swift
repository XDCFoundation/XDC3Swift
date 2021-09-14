//
//  ABIEvent.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation

public protocol ABIEvent {
    static var name: String { get }
    static var types: [ABIType.Type] { get }
    static var typesIndexed: [Bool] { get }

    var log: XDCLog { get }
    init?(topics: [ABIDecoder.DecodedValue], data: [ABIDecoder.DecodedValue], log: XDCLog) throws
    
    static func signature() throws -> String
}

extension ABIEvent {
    public static func checkParameters(_ topics: [ABIDecoder.DecodedValue], _ data: [ABIDecoder.DecodedValue]) throws {
        let indexedCount = Self.typesIndexed.filter { $0 == true }.count
        let unindexedCount = Self.typesIndexed.filter { $0 == false }.count
        
        guard Self.typesIndexed.count == Self.types.count, topics.count == indexedCount, data.count == unindexedCount else {
            throw ABIError.incorrectParameterCount
        }
    }
    
    public static func signature() throws -> String {
        let sig = try ABIFunctionEncoder.signature(name: Self.name, types: Self.types)
        return String(bytes: sig)
    }
}
