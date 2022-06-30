//
//  ConverterProtocols.swift
//  Currency Converter
//
//  Created by Ömer Faruk Varoğlu on 28.06.2022.
//

import Foundation

protocol ConverterViewModelProtocol {
    var delegate: ConverterViewModelDelegate? { get set }
    var currencyList: [String] { get set }
    func load()
    func convert(amount: String)
    func submitCurrency(sellAmount: String, receiveAmount: String, sellCurrency: String, receiveCurrency: String)
}

enum ConverterViewModelOutput: Equatable {
    case titleUpdate(String)
    case successConvert(String)
    case wrongConvert
    case reloadBalance
}

protocol ConverterViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: ConverterViewModelOutput)
}
