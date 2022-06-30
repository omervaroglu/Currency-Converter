//
//  APIRoter+Path.swift
//  Currency Converter
//
//  Created by Ömer Faruk Varoğlu on 28.06.2022.
//

import Foundation

extension APIRouter {
    
    // MARK: - Path
    var path: String {
        switch self {
        case .convert(amount: let amount, sellCurrency: let sellCurrency, buyCurrency: let buyCurrency):
            return "currency/commercial/exchange/\(amount)-\(sellCurrency)/\(buyCurrency)/latest"
        }
    }
}
