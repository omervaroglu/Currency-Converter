//
//  CurrencyConverterTests.swift
//  CurrencyConverterTests
//
//  Created by Ömer Faruk Varoğlu on 30.06.2022.
//

import XCTest
@testable import Currency_Converter

class CurrencyConverterTests: XCTestCase {
    
    private var view: MockView!
    private var viewModel: ConverterViewModel!
    
    override func setUpWithError() throws {
        view = MockView()
        viewModel = ConverterViewModel()
        viewModel.delegate = view
    }

    func testload() throws {
        
        //Given:
        let currencies = [Currencies.EUR.rawValue, Currencies.USD.rawValue, Currencies.JPY.rawValue]
        let commissionRulesCount = 5
        
        //When:
        viewModel.load()
        
        //Then:
        switch view.outputs[0] {
        case .titleUpdate(_):
            break //Test Succeeded
        default:
            XCTFail("First output should be `titleUpdate`.")
        }
        
        let expectedCurrencyList =  currencies
        XCTAssertEqual(viewModel.currencyList, expectedCurrencyList)
        
        XCTAssertEqual(viewModel.convertCount, commissionRulesCount)
        
        let expectedBalanceList: [Balance] = [Balance(currency: "EUR", amount: "1000.00"),
                                              Balance(currency: "USD", amount: "0.00"),
                                              Balance(currency: "JPY", amount: "0.00")]
        XCTAssertEqual(viewModel.balanceList, expectedBalanceList)
    }
    
    func testSubmitCurrency() throws {
        //Given:
        let sellAmount = "10.0"
        let receiveAmount = "10.4"
        let sellCurrency = "EUR"
        let receiveCurrency = "USD"
        viewModel.balanceList = [Balance(currency: "EUR", amount: "1000.0"),
                                 Balance(currency: "USD", amount: "0.0"),
                                 Balance(currency: "JPY", amount: "0.0") ]
        viewModel.convertCount = 5

        //When:
        viewModel.submitCurrency(sellAmount: sellAmount, receiveAmount: receiveAmount, sellCurrency: sellCurrency, receiveCurrency: receiveCurrency)

        //Then:
        switch view.outputs[0] {
        case .reloadBalance: break // Test Succeeded
        default:
            XCTFail("First output should be `Something went wrong in API Call`.")
        }
    }
}


private class MockView: ConverterViewModelDelegate {
    
    var outputs: [ConverterViewModelOutput] = []
    
    func handleViewModelOutput(_ output: ConverterViewModelOutput) {
        outputs.append(output)
    }

}
