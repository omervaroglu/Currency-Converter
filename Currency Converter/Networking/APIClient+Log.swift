//
//  APIClient+Log.swift
//  Currency Converter
//
//  Created by Ömer Faruk Varoğlu on 28.06.2022.
//

import Foundation
import Alamofire

extension APIClient {
    
    internal func logRequest(for jsonResponse: AFDataResponse<Data?>, response: Codable, requestParams: Data?, urlRequest: URLRequest?, showLoader: Bool?) {
        print("\n\n\n\n\n🌀🌀🌀🌀🌀")
        print("[API Request Start]")
        print("[Start Date: \(Date())]")
        print("🌐 URL: \((jsonResponse.request?.url)!) #\(urlRequest?.httpMethod?.uppercased() ?? "NIL") #ShowLoader: \(showLoader ?? false)")
        print("🤜🏻 Request Header: \(urlRequest?.allHTTPHeaderFields ?? [:])")
        if let json = try? JSONSerialization.jsonObject(with:requestParams ?? Data() , options: []) as? [String: Any] {
            print("🤜🏻 Request Params: \(String(describing: json))")
        }
        print("---------------")
        print("✅ Response Header: \(jsonResponse.response?.allHeaderFields ?? [:])")
        if let dict = response.dictionary {
            print("✅ Response: \(String(describing: dict))")
        } else {
            print("✅ Response: \(String(describing: response))")
        }
        
        
        print("⏰ RequestStart: \(String(describing: jsonResponse.metrics?.transactionMetrics.first?.requestStartDate)))")
        print("⏰ ResponseEnd: \(String(describing: jsonResponse.metrics?.transactionMetrics.first?.responseEndDate)))")
        print("[End Date: \(Date())]")
        print("[API Request End]")
        print("🌀🌀🌀🌀🌀\n\n\n\n\n")
    }
    
    
    internal func printOriginalJson(with decryptedData: Data) {
        if let json = try? JSONSerialization.jsonObject(with: decryptedData, options: []) as? [String: Any] {
            print("‼️ WE FOUND THIS JSON INSTEAD: \(json)")
        }
    }
}
