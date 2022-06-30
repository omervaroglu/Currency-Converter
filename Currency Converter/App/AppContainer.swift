//
//  AppContainer.swift
//  Currency Converter
//
//  Created by Ömer Faruk Varoğlu on 28.06.2022.
//

import Foundation

final class AppContainer {
    
    public static var shared = AppContainer()
    
    let router = AppRouter()
}
