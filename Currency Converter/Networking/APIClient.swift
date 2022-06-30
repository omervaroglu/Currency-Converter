//
//  APIClient.swift
//  Currency Converter
//
//  Created by Ömer Faruk Varoğlu on 28.06.2022.
//

import Foundation
import Alamofire
import RxSwift

class APIClient {
    
    func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = AF.request(urlConvertible).validate().response { response in
                switch response.result {
                case .success(let value):
                    do {
                        let result = try JSONDecoder().decode(T.self, from: response.data ?? Data())
                        self.logRequest(for: response, response: result, requestParams: urlConvertible.urlRequest?.httpBody, urlRequest: urlConvertible.urlRequest, showLoader: false)
                        DispatchQueue.main.async {
                            observer.onNext(result)
                            observer.onCompleted()
                        }
                    } catch(_) {
                        self.printOriginalJson(with: response.data ?? Data())
                        DispatchQueue.main.async {
                            observer.on(.error(ApiError.jsonDecode))
                        }
                    }
                case .failure(let error):
                    self.printOriginalJson(with: response.data ?? Data())
                    do {
//                        let result = try JSONDecoder().decode(GenericErrorResponse.self, from: response.data ?? Data())
//                        print(result)
                        switch response.response?.statusCode {
                        case 400:
                            observer.onError(ApiError.badRequest(message: error.errorDescription))
                        case 401:
                            observer.onError(ApiError.unauthorized(message: error.errorDescription))
                        case 403:
                            observer.onError(ApiError.forbidden(message: error.errorDescription))
                        case 404:
                            observer.onError(ApiError.notFound(message: error.errorDescription))
                        case 409:
                            observer.onError(ApiError.conflict(message: error.errorDescription))
                        case 422:
                            observer.onError(ApiError.unProccesableEntity(message: error.errorDescription))
                        case 500:
                            observer.onError(ApiError.internalServerError(message: error.errorDescription))
                        default:
                            observer.onError(error)
                        }
                    } catch(let error) {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
