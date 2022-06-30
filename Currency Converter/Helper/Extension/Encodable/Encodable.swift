//
//  Encodable.swift
//  Currency Converter
//
//  Created by Ömer Faruk Varoğlu on 28.06.2022.
//

import Foundation
import Alamofire

extension Encodable {
    
    /// Codable to Dictionary
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    var headers: HTTPHeaders? {
        guard let httpHeaders = (self.dictionary?.filter { $0.value is String }.map { HTTPHeader(name: $0.key, value: ($0.value as! String)) }) else {
            return nil
        }
        return HTTPHeaders(httpHeaders)
    }
}
