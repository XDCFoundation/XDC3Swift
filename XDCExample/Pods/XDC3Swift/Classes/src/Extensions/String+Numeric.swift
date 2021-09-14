//
//  String+Numeric.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation

public extension XDC3Extensions where Base == String {
    var isNumeric: Bool {
        guard !base.isEmpty else {
            return false
        }
        
        guard !base.starts(with: "-") else {
            return String(base.dropFirst()).xdc3.isNumeric
        }
        
        return base.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
