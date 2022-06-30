//
//  ConverterViewController.swift
//  Currency Converter
//
//  Created by Ömer Faruk Varoğlu on 28.06.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ConverterViewController: UIViewController {

    @IBOutlet private weak var balanceCollectionView: UICollectionView!
    @IBOutlet private weak var sellAmountTextField: UITextField!
    @IBOutlet private weak var receiveAmountLabel: UILabel!
    @IBOutlet private weak var sellCurrencyContainerView: UIView!
    @IBOutlet private weak var receiveCurrencyContainerView: UIView!
    @IBOutlet private weak var sellCurrencyLabel: UILabel!
    @IBOutlet private weak var receiveCurrencyLabel: UILabel!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var changeSellCurrencyButton: UIButton!
    @IBOutlet private weak var changeReceiveCurrencyButton: UIButton!
    
    var viewModel: ConverterViewModel! {
        didSet {
            viewModel.delegate = self
            viewModel.load()
        }
    }
    
    let disposeBag = DisposeBag()
    
    var sellMenuItems: [UIAction] = []
    var receiveMenuItems: [UIAction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCurrencyActions()
        setCollectionView()
        setBinding()
        setUI()
    }
    
    private func setBinding() {
        observeSellReceiveCurrencies()
        configureTextField()
        actionSellCurrencyButton()
        actionRecieveCurrencyButton()
        actionSubmitButton()
    }
    
    private func setUI() {
        self.overrideUserInterfaceStyle = .light
        self.navigationController?.navigationBar.backgroundColor = UIColor(hexString: "#298ACD")
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.backgroundColor = UIColor(hexString: "#298ACD")
        view.addSubview(statusBarView)

        submitButton.layer.cornerRadius = 25.0
        
        sellAmountTextField.keyboardType = .decimalPad
        sellAmountTextField.addDoneButtonOnKeyboard()
        sellAmountTextField.attributedPlaceholder = NSAttributedString(
            string: "0.0",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
    }
    
    private func setCollectionView() {
        balanceCollectionView.delegate = self
        balanceCollectionView.dataSource = self
        self.balanceCollectionView.registerCells([BalanceCollectionViewCell.self])
    }
    
    ///to create menus automatically and it helps to add new currency
    private func setCurrencyActions() {
        viewModel.currencyList.forEach { [weak self] currency in
            guard let self = self else { return }
            
            let sellAction = UIAction(title: currency, handler: { (_) in
                self.viewModel.sellCurrency.accept(currency)
                self.viewModel.convert(amount: self.sellAmountTextField.text ?? "")
            })
            self.sellMenuItems.append(sellAction)
            
            let receiveAction = UIAction(title: currency, handler: { (_) in
                self.viewModel.receiveCurrency.accept(currency)
                self.viewModel.convert(amount: self.sellAmountTextField.text ?? "")
            })
            self.receiveMenuItems.append(receiveAction)
        }
    }
}

//MARK: - Bindings
extension ConverterViewController {
    
    private func observeSellReceiveCurrencies() {
        viewModel.sellCurrency.asObservable().subscribe(onNext: { currency in
            self.sellCurrencyLabel.text = currency
        }).disposed(by: disposeBag)
        
        viewModel.receiveCurrency.asObservable().subscribe(onNext: { currency in
            self.receiveCurrencyLabel.text = currency
        }).disposed(by: disposeBag)
    }
    
    private func configureTextField() {
        sellAmountTextField.rx.controlEvent([.editingChanged])
            .bind { [weak self] char in
                guard let self = self else { return }
                if self.sellAmountTextField.text?.first?.isNumber == false {
                    self.sellAmountTextField.text = "0" + (self.sellAmountTextField.text ?? "")
                }
                if let amount = self.sellAmountTextField.text {
                    self.viewModel.convert(amount: amount)
                }
        }.disposed(by: disposeBag)
    }
    
    /// for select sell currency
    private func actionSellCurrencyButton() {
        changeSellCurrencyButton.rx.tap.bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.changeSellCurrencyButton.showsMenuAsPrimaryAction = true
            self.changeSellCurrencyButton.menu = UIMenu(title:"", image: nil, identifier: nil, options: [], children: self.sellMenuItems)
        }).disposed(by: disposeBag)
    }
    
    /// for select receive currency
    private func actionRecieveCurrencyButton() {
        changeReceiveCurrencyButton.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.changeReceiveCurrencyButton.showsMenuAsPrimaryAction = true
            self.changeReceiveCurrencyButton.menu = UIMenu(title:"", image: nil, identifier: nil, options: [], children: self.receiveMenuItems)
        }).disposed(by: disposeBag)
    }
    
    private func actionSubmitButton() {
        submitButton.rx.tap.bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            if self.viewModel.sellCurrency.value == self.viewModel.receiveCurrency.value {
                return
            }
            self.viewModel.submitCurrency(sellAmount: self.sellAmountTextField.text ?? "", receiveAmount: self.receiveAmountLabel.text ?? "", sellCurrency: self.viewModel.sellCurrency.value, receiveCurrency: self.viewModel.receiveCurrency.value)
        }).disposed(by: disposeBag)
    }
}

//MARK: - handleViewModelOutput
extension ConverterViewController: ConverterViewModelDelegate {
    func handleViewModelOutput(_ output: ConverterViewModelOutput) {
        switch output {
        case .titleUpdate(let title):
            self.title = title
        case .wrongConvert:
            break
        case .successConvert(let amount):
            receiveAmountLabel.text = amount
        case .reloadBalance:
            self.balanceCollectionView.reloadData()
        }
    }
}

//MARK: - CollectionView
extension ConverterViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.balanceList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BalanceCollectionViewCell.nameOfClass, for: indexPath) as! BalanceCollectionViewCell
        let balance = viewModel.balanceList[indexPath.row]
        cell.setCell(currency: balance.currency ?? "", amount: balance.amount ?? "")
        return cell
    }
}

enum Currencies: String, CaseIterable, Equatable {
    case EUR = "EUR"
    case USD = "USD"
    case JPY = "JPY"
}
