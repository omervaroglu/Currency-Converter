//
//  ConverterResponseModel.swift
//  Currency Converter
//
//  Created by Ömer Faruk Varoğlu on 28.06.2022.
//

import Foundation

struct ConverterResponseModel: Codable {
    let amount: String
    let currency: String
    
    enum CodingKeys: String, CodingKey {
        case amount
        case currency
    }
}
