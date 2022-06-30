//
//  Request.swift
//  Currency Converter
//
//  Created by Ömer Faruk Varoğlu on 28.06.2022.
//

import Foundation
import RxSwift

extension APIClient {
    
    static func convert(amount: String, sellCurrency: String, buyCurrency: String) -> Observable<ConverterResponseModel> {
        return APIClient().request(APIRouter.convert(amount: amount, sellCurrency: sellCurrency, buyCurrency: buyCurrency))
    }
}

