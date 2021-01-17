//
//  ConverterGridPresenterTests.swift
//  CurrencyConversionTests
//
//  Created by Wen Chien Chen on 2021/1/14.
//

import XCTest
@testable import CurrencyConversion

final class ConverterGridPresenterTests: XCTestCase {
    private var presenter: ConverterGridPresenter!
    private var view: MockConverterGridViewInput!
    private var interactor: MockConverterGridInteractorInput!
    private var router: MockConverterGridRouterInput!
    
    override func setUp() {
        super.setUp()
        view = MockConverterGridViewInput()
        interactor = MockConverterGridInteractorInput()
        router = MockConverterGridRouterInput()
        presenter = ConverterGridPresenter()
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
    }

    override func tearDown() {
        view = nil
        interactor = nil
        router = nil
        presenter = nil
        super.tearDown()
    }
    
    // ------ ConverterGridViewOutput Tests -----
    
    func testViewIsReady() {
        // when
        presenter.viewIsReady()
        
        // then
        XCTAssertTrue(interactor.fetchCurrenciesCalled)
        XCTAssertTrue(interactor.fetchExchangeRatesCalled)
    }
    
    func testTappedCurrencyButton() {
        // when
        presenter.tappedCurrencyButton()
        
        // then
        XCTAssertTrue(interactor.fetchCurrenciesCalled)
    }
    
    func testDidSelectCurrencyWithAllDataReady() {
        // given
        let TWDCurrency = Currency(name: "Taiwan Dollar", shortName: "TWD")
        let USDCurrency = Currency(name: "United States Dollar", shortName: "USD")
        let TWDExchangeRate = ExchangeRate(fromCurrency: "USD", toCurrency: "TWD", rate: 28.1)
        let USDExchangeRate = ExchangeRate(fromCurrency: "", toCurrency: "", rate: 1)
        presenter.currencies = [TWDCurrency, USDCurrency]
        presenter.exchangeRates = [TWDExchangeRate, USDExchangeRate]
        presenter.currentAmount = 100

        // when
        presenter.didSelectCurrency(with: TWDCurrency)
        
        // then
        XCTAssertTrue(presenter.selectedCurrency?.name == "Taiwan Dollar")
        XCTAssertTrue(presenter.selectedCurrency?.shortName == "TWD")
        XCTAssertTrue(presenter.exchangeRateCellModels.first?.amount == 100)
        XCTAssertTrue(view.updateCurrencyButtonTextCalled)
        XCTAssertTrue(view.exchangeRatesIsReadyCalled)
        
    }
    
    func testDidSelectCurrencyWithChangeRateNotReady() {
        // given
        let TWDCurrency = Currency(name: "Taiwan Dollar", shortName: "TWD")
        
        // when
        presenter.didSelectCurrency(with: TWDCurrency)
        
        // then
        XCTAssertTrue(presenter.selectedCurrency?.name == "Taiwan Dollar")
        XCTAssertTrue(presenter.selectedCurrency?.shortName == "TWD")
        XCTAssertTrue(view.updateCurrencyButtonTextCalled)
        XCTAssertFalse(view.exchangeRatesIsReadyCalled)
    }
    
    func testDidChangeAmountWithExchangeRateCellModelNotNil() {
        // given
        let exchangeRateCellModel = ExchangeRateCellModel(fromCurrencyName: "USD",
                                                          toCurrencyFullName: "Taiwan Dollar",
                                                          toCurrencyShortName: "TWD",
                                                          rate: 28.1,
                                                          amount: 0.0)
        presenter.exchangeRateCellModels = [exchangeRateCellModel]
        let afterExchangePrice = 28.1 * 100
        // when
        presenter.didChangeAmount(with: 100)
        
        // then
        XCTAssertTrue(presenter.currentAmount == 100)
        XCTAssertTrue(presenter.exchangeRateCellModels.first?.amount == afterExchangePrice)
        XCTAssertTrue(view.exchangeRatesIsReadyCalled)
    }
    
    func testDidChangeAmountWithExchangeRateCellModelNil() {
        // given
        presenter.exchangeRateCellModels = []
        
        // when
        presenter.didChangeAmount(with: 100)
        
        // then
        XCTAssertTrue(presenter.currentAmount == 100)
        XCTAssertNil(presenter.exchangeRateCellModels.first)
        XCTAssertFalse(view.exchangeRatesIsReadyCalled)
    }
    
    // ------ ConverterGridInteractorOutput tests ------
    
    func testFetchedCurrencies() {
        // given
        let TWDCurrency = Currency(name: "Taiwan Dollar", shortName: "TWD")
        
        // when
        presenter.fetchedCurrencies([TWDCurrency])
        
        // then
        XCTAssertTrue(presenter.currencies.count == 1)
        XCTAssertTrue(presenter.currencies.first?.shortName == "TWD")
        XCTAssertTrue(presenter.currencies.first?.name == "Taiwan Dollar")
        XCTAssertTrue(view.currenciesIsReadyCalled)
    }
    
    func testFetchedExchangeRatesWithCurrenciesNotNil() {
        // given
        let TWDCurrency = Currency(name: "Taiwan Dollar", shortName: "TWD")
        let USDCurrency = Currency(name: "United States Dollar", shortName: "USD")
        let TWDExchangeRate = ExchangeRate(fromCurrency: "USD", toCurrency: "TWD", rate: 28.1)
        let USDExchangeRate = ExchangeRate(fromCurrency: "", toCurrency: "", rate: 1)
        presenter.currencies = [TWDCurrency, USDCurrency]
        
        // when
        presenter.fetchedExchangeRates([TWDExchangeRate, USDExchangeRate])
        
        // then
        XCTAssertTrue(presenter.exchangeRateCellModels.count == 1)
        XCTAssertTrue(presenter.exchangeRateCellModels.first?.fromCurrencyName == "USD")
        XCTAssertTrue(presenter.exchangeRateCellModels.first?.toCurrencyFullName == "Taiwan Dollar")
        XCTAssertTrue(presenter.exchangeRateCellModels.first?.toCurrencyShortName == "TWD")
        XCTAssertTrue(presenter.exchangeRateCellModels.first?.rate == 28.1)
        XCTAssertTrue(presenter.exchangeRateCellModels.first?.amount == 0.0)
        XCTAssertTrue(view.exchangeRatesIsReadyCalled)
    }
}
