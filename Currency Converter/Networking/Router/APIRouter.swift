//
//  APIRouter.swift
//  Currency Converter
//
//  Created by Ömer Faruk Varoğlu on 28.06.2022.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case convert(amount:String, sellCurrency:String, buyCurrency: String)

    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try NetworkConstant.baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        //Http method
        urlRequest.httpMethod = method.rawValue

        //Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
}

