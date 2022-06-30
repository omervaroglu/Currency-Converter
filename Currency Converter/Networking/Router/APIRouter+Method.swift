//
//  APIRouter+Method.swift
//  Currency Converter
//
//  Created by Ömer Faruk Varoğlu on 28.06.2022.
//

import Foundation
import Alamofire

extension APIRouter {
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .convert:
            return .get
        }
    }
}
