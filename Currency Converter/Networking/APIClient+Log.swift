//
//  APIClient+Log.swift
//  Currency Converter
//
//  Created by Γmer Faruk VaroΔlu on 28.06.2022.
//

import Foundation
import Alamofire

extension APIClient {
    
    internal func logRequest(for jsonResponse: AFDataResponse<Data?>, response: Codable, requestParams: Data?, urlRequest: URLRequest?, showLoader: Bool?) {
        print("\n\n\n\n\nπππππ")
        print("[API Request Start]")
        print("[Start Date: \(Date())]")
        print("π URL: \((jsonResponse.request?.url)!) #\(urlRequest?.httpMethod?.uppercased() ?? "NIL") #ShowLoader: \(showLoader ?? false)")
        print("π€π» Request Header: \(urlRequest?.allHTTPHeaderFields ?? [:])")
        if let json = try? JSONSerialization.jsonObject(with:requestParams ?? Data() , options: []) as? [String: Any] {
            print("π€π» Request Params: \(String(describing: json))")
        }
        print("---------------")
        print("β Response Header: \(jsonResponse.response?.allHeaderFields ?? [:])")
        if let dict = response.dictionary {
            print("β Response: \(String(describing: dict))")
        } else {
            print("β Response: \(String(describing: response))")
        }
        
        
        print("β° RequestStart: \(String(describing: jsonResponse.metrics?.transactionMetrics.first?.requestStartDate)))")
        print("β° ResponseEnd: \(String(describing: jsonResponse.metrics?.transactionMetrics.first?.responseEndDate)))")
        print("[End Date: \(Date())]")
        print("[API Request End]")
        print("πππππ\n\n\n\n\n")
    }
    
    
    internal func printOriginalJson(with decryptedData: Data) {
        if let json = try? JSONSerialization.jsonObject(with: decryptedData, options: []) as? [String: Any] {
            print("βΌοΈ WE FOUND THIS JSON INSTEAD: \(json)")
        }
    }
}
