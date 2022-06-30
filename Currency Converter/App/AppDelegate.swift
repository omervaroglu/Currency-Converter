//
//  AppDelegate.swift
//  Currency Converter
//
//  Created by Ömer Faruk Varoğlu on 27.06.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppContainer.shared.router.start()
        return true
    }
    
}

