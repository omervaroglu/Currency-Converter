//
//  NetworkConstant.swift
//  Currency Converter
//
//  Created by Ömer Faruk Varoğlu on 28.06.2022.
//

import Foundation

struct NetworkConstant {
    
    static let baseUrl = "http://api.evp.lt/"
    
}

enum ApiError: Error {
    case badRequest(message: String?)             //Status code 400
    case unauthorized(message: String?)           //Status code 401
    case forbidden(message: String?)              //Status code 403
    case notFound(message: String?)               //Status code 404
    case conflict(message: String?)               //Status code 409
    case unProccesableEntity(message: String?)    //Statys code 422
    case internalServerError(message: String?)    //Status code 500
    
    case jsonDecode
}
