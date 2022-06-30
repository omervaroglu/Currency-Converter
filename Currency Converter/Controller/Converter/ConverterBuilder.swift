//
//  ConverterBuilder.swift
//  Currency Converter
//
//  Created by Ömer Faruk Varoğlu on 28.06.2022.
//

import Foundation
import UIKit

class ConverterBuilder {
    
    static func make() -> ConverterViewController {
        let storyboard = UIStoryboard(name: "Converter", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ConverterViewController") as! ConverterViewController
        viewController.viewModel = ConverterViewModel()
        return viewController
    }
}
