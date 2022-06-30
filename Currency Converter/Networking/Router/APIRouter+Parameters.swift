//
//  APIRouter+Parameters.swift
//  Currency Converter
//
//  Created by Ömer Faruk Varoğlu on 28.06.2022.
//

import Foundation
import Alamofire

extension APIRouter {
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .convert:
            return [:]
        }
    }
}

