//
//  String.swift
//  Currency Converter
//
//  Created by Ömer Faruk Varoğlu on 30.06.2022.
//

import Foundation

extension String
{
    func containsNumbers() -> Bool
    {
        let numberRegEx  = ".*[0-9]+.*"
        let testCase     = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        return testCase.evaluate(with: self)
    }
}
