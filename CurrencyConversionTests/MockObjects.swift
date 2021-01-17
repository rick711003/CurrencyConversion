//
//  MockObjects.swift
//  CurrencyConversionTests
//
//  Created by Wen Chien Chen on 2021/1/14.
//

import Foundation

import UIKit
@testable import CurrencyConversion

class MockConverterGridViewInput: ConverterGridViewInput {
    var exchangeRatesIsReadyCalled = false
    func exchangeRatesIsReady() {
        exchangeRatesIsReadyCalled = true
    }
    
    var currenciesIsReadyCalled = false
    func currenciesIsReady() {
        currenciesIsReadyCalled = true
    }
    
    var updateCurrencyButtonTextCalled = false
    func updateCurrencyButtonText() {
        updateCurrencyButtonTextCalled = true
    }
}

class MockConverterGridInteractorInput: ConverterGridInteractorInput {
    var fetchCurrenciesCalled = false
    func fetchCurrencies() {
        fetchCurrenciesCalled = true
    }
    
    var fetchExchangeRatesCalled = false
    func fetchExchangeRates() {
        fetchExchangeRatesCalled = true
    }
}

class MockConverterGridViewOutput: ConverterGridViewOutput {
    
    var mockExchangeRateCellModels: [ExchangeRateCellModel] = []
    var exchangeRateCellModels: [ExchangeRateCellModel] {
        return mockExchangeRateCellModels
    }
    
    var mockCurrencies: [Currency] = []
    var currencies: [Currency] {
        return mockCurrencies
    }
    
    var mockSelectedCurrency: Currency? = nil
    var selectedCurrency: Currency? {
        return mockSelectedCurrency
    }
    
    var viewIsReadyCalled = false
    func viewIsReady() {
        viewIsReadyCalled = true
    }
    
    var tappedCurrencyButtonCalled = false
    func tappedCurrencyButton() {
        tappedCurrencyButtonCalled = true
    }
    
    var didSelectCurrencyCalled = false
    var mockDidSelectCurrency: Currency?
    func didSelectCurrency(with currency: Currency) {
        mockDidSelectCurrency = currency
        didSelectCurrencyCalled = true
    }
    
    var didChangeAmountCalled = false
    var mockAmount: Double = 0.0
    func didChangeAmount(with amount: Double) {
        mockAmount = amount
        didChangeAmountCalled = true
    }
    
    
}

class MockConverterGridRouterInput: ConverterGridRouterInput {}

class MockConverterGridInteractorOutput: ConverterGridInteractorOutput {
    var fetchedCurrenciesCalled = false
    var currencies: [Currency] = []
    func fetchedCurrencies(_ currencies: [Currency]) {
        fetchedCurrenciesCalled = true
        self.currencies = currencies
    }
    
    var fetchedExchangeRatesCalled = false
    var exchangeRates: [ExchangeRate] = []
    func fetchedExchangeRates(_ exchangeRates: [ExchangeRate]) {
        fetchedExchangeRatesCalled = true
        self.exchangeRates = exchangeRates
    }
}

class MockWebService: WebService {
    var fetchCurrenciesListCalled = false
    var mockCurrencies: [Currency] = []
    var fetchCurrenciesListError: Error? = nil
    override func fetchCurrenciesList(completion: @escaping (_ modelType: [Currency]?, _ error: Error?) -> Void) {
        fetchCurrenciesListCalled = true
        if mockCurrencies.count > 0 {
            completion(mockCurrencies, nil)
        } else if fetchCurrenciesListError != nil {
            completion(nil, fetchCurrenciesListError)
        }
    }
    
    var fetchExchangeRatesCalled = false
    var mockExchangeRates: [ExchangeRate] = []
    var fetchExchangeRatesError: Error? = nil
    override func fetchExchangeRates(completion: @escaping (_ modelType: [ExchangeRate]?, _ error: Error?) -> Void) {
        fetchExchangeRatesCalled = true
        if mockExchangeRates.count > 0 {
            completion(mockExchangeRates, nil)
        } else if fetchExchangeRatesError != nil {
            completion(nil, fetchExchangeRatesError)
        }
    }
}

class MockCacheManager: CacheManager {
    
    var saveExchangeRatesToLocalCalled = false
    override func saveExchangeRatesToLocal(exchangeRates: [ExchangeRate]) {
        saveExchangeRatesToLocalCalled = true
    }
    
    var getExchangeRatesFromLocalCalled = false
    var mockExchangeRates: [ExchangeRate]? = nil
    override func getExchangeRatesFromLocal() -> [ExchangeRate]? {
        getExchangeRatesFromLocalCalled = true
        return mockExchangeRates
    }
    
    var mockLastFetchExchangeRateLess30Min: Bool = false
    var lastFetchExchangeRateOver30MinCalled = false
    override func lastFetchExchangeRateOver30Minute() -> Bool {
        lastFetchExchangeRateOver30MinCalled = true
        return mockLastFetchExchangeRateLess30Min
    }
    
    var saveCurrenciesToLocalCalled = false
    override func saveCurrenciesToLocal(currencies: [Currency]) {
        saveCurrenciesToLocalCalled = true
    }
    
    var getCurrenciesFromLocalCalled = false
    var mockCurrencies: [Currency]? = nil
    override func getCurrenciesFromLocal() -> [Currency]? {
        getCurrenciesFromLocalCalled = true
        return mockCurrencies
    }
    
    var mockLastFetchCurrenciesLess30Min: Bool = false
    var lastFetchCurrenciesOver30MinCalled = false
    override func lastFetchCurrenciesOver30Minute() -> Bool {
        lastFetchCurrenciesOver30MinCalled = true
        return mockLastFetchCurrenciesLess30Min
    }
}

class MockURLSession: URLSession {
    private let mockTask: MockTask
    var cachedUrl: URL?


    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        mockTask = MockTask(data: data, urlResponse: urlResponse, error:
            error)
    }

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        self.cachedUrl = url
        mockTask.completionHandler = completionHandler
        return mockTask
    }
}

class MockTask: URLSessionDataTask {
    private let data: Data?
    private let urlResponse: URLResponse?

    private let _error: Error?
    override var error: Error? {
        return _error
    }

    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)!

    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self._error = error
    }

    override func resume() {
        DispatchQueue.main.async {
            self.completionHandler(self.data, self.urlResponse, self.error)
        }
    }
}
