//
//  Double.swift
//  Currency Converter
//
//  Created by Ömer Faruk Varoğlu on 30.06.2022.
//

import Foundation

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
