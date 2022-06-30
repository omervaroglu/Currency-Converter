//
//  ConverterViewModel.swift
//  Currency Converter
//
//  Created by Ömer Faruk Varoğlu on 28.06.2022.
//

import Foundation
import RxSwift
import RxRelay
import UIKit

class ConverterViewModel: ConverterViewModelProtocol {
    
    var delegate: ConverterViewModelDelegate?
    
    var currencyList: [String] = []
    var sellCurrency = BehaviorRelay<String>(value: "EUR")
    var receiveCurrency = BehaviorRelay<String>(value: "USD")
    var balanceList: [Balance] = []
    var convertCount = 0
    var commissionPercentage = 0.07
    var commissionFee: Double = 0.0
    var feeType: CommissionFeeRules = .fisrtFiveFree
    
    private let disposeBag = DisposeBag()
    
    func load() {
        notify(.titleUpdate("CURRENCY CONVERTER"))
        setCurrencyList()
        setBalanceList()
        prepareCommission(feeType: feeType)
    }
    
    func convert(amount: String) {
        if !isValidAmount(amount: amount) {
            self.notify(.successConvert("0.0"))
            return
        }
        
        APIClient.convert(amount: amount, sellCurrency: sellCurrency.value, buyCurrency: receiveCurrency.value)
            .observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.notify(.successConvert(response.amount))
            }, onError: { error in
                switch error {
                case ApiError.badRequest(message: let message):
                    AlertManager.shared.showNoAction(title: message ?? "", button: "Okay")
                case ApiError.conflict(message: let message):
                    AlertManager.shared.showNoAction(title: message ?? "", button: "Okay")
                case ApiError.notFound(message: let message):
                    AlertManager.shared.showNoAction(title: message ?? "", button: "Okay")
                case ApiError.unProccesableEntity(message: let message):
                    AlertManager.shared.showNoAction(title: message ?? "", button: "Okay")
                default:
                    AlertManager.shared.showNoAction(title: "Something wrent wrong!", button: "Okay")
                }
                self.notify(.wrongConvert)
            }).disposed(by: disposeBag)
    }

    private func setCurrencyList() {
        Currencies.allCases.forEach { [weak self] currency in
            guard let self = self else { return }
            self.currencyList.append(currency.rawValue)
        }
    }
    
    private func setBalanceList() {
        var balanceList : [Balance] = []
        Currencies.allCases.forEach { currency in
            var balance = Balance()
            if currency.rawValue == "EUR" {
                balance.amount = "1000.00"
                balance.currency = currency.rawValue
            } else {
                balance.amount = "0.00"
                balance.currency = currency.rawValue
            }
            balanceList.append(balance)
        }
        self.balanceList = balanceList
    }
    
    private func isValidAmount(amount: String) -> Bool {
        if amount.last?.isNumber == false  {
            return false
        }
        if amount.count == 0  && !(amount.containsNumbers()){
            return false
        }
        return true
    }
    
    private func notify(_ output: ConverterViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
}

//MARK: - Commission logic
extension ConverterViewModel {
    func submitCurrency(sellAmount: String, receiveAmount: String, sellCurrency: String, receiveCurrency: String) {
        if !(isValidAmount(amount: sellAmount)) {
            return
        }
        for balance in balanceList {
            let currenctAmount = Double(sellAmount) ?? 0.0
            let balanceAmount = Double(balance.amount ?? "") ?? 0.0
            if balance.currency == sellCurrency && currenctAmount <= balanceAmount {
                updateBalance(sellAmount: sellAmount, receiveAmount: receiveAmount, sellCurrency: sellCurrency, receiveCurrency: receiveCurrency)
                return
            }
        }
        AlertManager.shared.showNoAction(title: "You have not enough " + sellCurrency , button: "Okay")
    }
    
    private func checkfreeCommissionFee(feeType: CommissionFeeRules, receiveAmount: String) {
        switch feeType {
        case .fisrtFiveFree:
            if convertCount <= 0 {
                self.commissionFee = (Double(receiveAmount) ?? 0.0) * self.commissionPercentage
            } else {
                convertCount -= 1
            }
        }
    }
    
    private func updateBalance(sellAmount: String, receiveAmount: String, sellCurrency: String, receiveCurrency: String) {
        var newBalanceList : [Balance] = []
        checkfreeCommissionFee(feeType: .fisrtFiveFree, receiveAmount: receiveAmount)
        for item in balanceList {
            if item.currency == sellCurrency {
                let newAmount = (Double(item.amount ?? "") ?? 0.0) - (Double(sellAmount) ?? 0.0)
                newBalanceList.append(Balance(currency: item.currency, amount: String(newAmount.roundToDecimal(2))))
            } else if item.currency == receiveCurrency {
                let newAmount = (Double(item.amount ?? "") ?? 0.0) - (Double(commissionFee)) + (Double(receiveAmount) ?? 0.0)
                newBalanceList.append(Balance(currency: item.currency, amount: String(newAmount.roundToDecimal(2))))
            } else {
                newBalanceList.append(Balance(currency: item.currency, amount: item.amount))
            }
        }
        self.balanceList = newBalanceList
        self.notify(.reloadBalance)
        
        let amountWithCommission = (Double(receiveAmount) ?? 0.0) - (Double(commissionFee))
        AlertManager.shared.showAsync(title: "Currency Converted", message: "You have converted \(sellAmount) \(sellCurrency) to \(amountWithCommission.roundToDecimal(2)) \(receiveCurrency). Commission fee - \(commissionFee.roundToDecimal(2))\(receiveCurrency)", action: [UIAlertAction(title: "Done", style: .default, handler: nil)])
    }
    
    func prepareCommission(feeType: CommissionFeeRules) {
        switch feeType {
        case .fisrtFiveFree:
            self.convertCount = 5
        }
    }
}

enum CommissionFeeRules {
    case fisrtFiveFree
}
