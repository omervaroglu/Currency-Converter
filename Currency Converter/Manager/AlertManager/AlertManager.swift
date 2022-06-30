//
//  AlertManager.swift
//  Currency Converter
//
//  Created by Ömer Faruk Varoğlu on 28.06.2022.
//

import Foundation
import UIKit

class AlertManager {
    
    static let shared = AlertManager()
    
    var viewController: UIViewController?
    
    /// Popup Create & Show
    private func show(title: String, message: String?, action: [UIAlertAction]?) {
        let alert = AlertController(title: title, message: message, preferredStyle: .alert)
        if (action != nil) {
            for item in action! {
                alert.addAction(item)
            }
        }
        alert.show()
        if viewController != nil {
            viewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    /// Show Alert With Dispatch Queue
    func showAsync(title: String, message: String?, action: [UIAlertAction]?) {
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 0.2), execute: {
            self.show(title: title, message: message, action: action)
        })
    }
    
    /// Show No Action Alert
    func showNoAction(title: String, button: String) {
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 0.2), execute: {
            self.show(title: title, message: "", action: [UIAlertAction(title: button, style: .default, handler: nil)])
        })
    }
    
    /// Show No Action Alert
    func showNoAction(message: String, button: String) {
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 0.2), execute: {
            self.show(title: "", message: message, action: [UIAlertAction(title: button, style: .default, handler: nil)])
        })
    }
}

class AlertController: UIAlertController {
    
    private var alertWindow: UIWindow?
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        alertWindow = nil
    }
    
    /// Show Popup On Route View
    func show() {
        if #available(iOS 13.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }.first
            if let windowScene = windowScene as? UIWindowScene {
                alertWindow = UIWindow(windowScene: windowScene)
            }
            alertWindow?.frame = UIScreen.main.bounds
            alertWindow?.windowLevel = UIWindow.Level.statusBar + 1
        } else {
            alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow?.windowLevel = UIWindow.Level.alert
        }
        
        alertWindow?.windowLevel = UIWindow.Level.statusBar + 1
        alertWindow?.rootViewController = UIViewController()
        alertWindow?.makeKeyAndVisible()
        alertWindow?.rootViewController?.present(self, animated: true, completion: nil)
    }
}
