//
//  ConverterGridInteractorTests.swift
//  CurrencyConversionTests
//
//  Created by Wen Chien Chen on 2021/1/14.
//

import XCTest
@testable import CurrencyConversion

final class ConverterGridInteractorTests: XCTestCase {
    private var interactor: ConverterGridInteractor!
    private var mockWebService: MockWebService!
    private var mockCacheManager: MockCacheManager!
    private var output: MockConverterGridInteractorOutput!
    
    override func setUp() {
        super.setUp()
        mockWebService = MockWebService(session: URLSession(configuration: .ephemeral,
                                                            delegate: nil,
                                                            delegateQueue: .main))
        mockCacheManager = MockCacheManager()
        output = MockConverterGridInteractorOutput()
        interactor = ConverterGridInteractor(service: mockWebService, cacheManager: mockCacheManager)
        interactor.output = output
    }

    override func tearDown() {
        interactor = nil
        mockWebService = nil
        mockCacheManager = nil
        output = nil
        super.tearDown()
    }
    
    func testFetchCurrenciesLessThan30Minute() {
        // given
        let TWDCurrency = Currency(name: "Taiwan Dollar", shortName: "TWD")
        mockWebService.mockCurrencies = [TWDCurrency]
        mockCacheManager.mockLastFetchCurrenciesLess30Min = true
        
        // when
        interactor.fetchCurrencies()
        
        // then
        XCTAssertTrue(mockWebService.fetchCurrenciesListCalled)
        XCTAssertTrue(mockCacheManager.saveCurrenciesToLocalCalled)
        XCTAssertTrue(output.fetchedCurrenciesCalled)
        XCTAssertEqual(output.currencies.count, mockWebService.mockCurrencies.count)
        XCTAssertEqual(output.currencies.first?.name, mockWebService.mockCurrencies.first?.name)
        XCTAssertEqual(output.currencies.first?.shortName, mockWebService.mockCurrencies.first?.shortName)
    }
    
    func testFetchCurrenciesLessThan30MinuteGetError() {
        // given
        let error = NSError(domain:"", code:404, userInfo:[ NSLocalizedDescriptionKey: "Can't found page"]) as Error
        mockWebService.fetchCurrenciesListError = error
        mockCacheManager.mockLastFetchCurrenciesLess30Min = true
        
        // when
        interactor.fetchCurrencies()
        
        // then
        XCTAssertTrue(mockWebService.fetchCurrenciesListCalled)
        XCTAssertFalse(mockCacheManager.saveCurrenciesToLocalCalled)
        XCTAssertFalse(output.fetchedCurrenciesCalled)
    }
    
    func testFetchCurrenciesOverThan30Minute() {
        // given
        let TWDCurrency = Currency(name: "Taiwan Dollar", shortName: "TWD")
        mockCacheManager.mockCurrencies = [TWDCurrency]
        mockCacheManager.mockLastFetchCurrenciesLess30Min = false
        
        // when
        interactor.fetchCurrencies()
        
        // then
        XCTAssertTrue(mockCacheManager.getCurrenciesFromLocalCalled)
        XCTAssertTrue(output.fetchedCurrenciesCalled)
        XCTAssertEqual(output.currencies.count, mockCacheManager.mockCurrencies?.count)
        XCTAssertEqual(output.currencies.first?.name, mockCacheManager.mockCurrencies?.first?.name)
        XCTAssertEqual(output.currencies.first?.shortName, mockCacheManager.mockCurrencies?.first?.shortName)
    }
    
    func testFetchCurrenciesOverThan30MinuteDataMiss() {
        // given
        mockCacheManager.mockLastFetchCurrenciesLess30Min = false
        
        // when
        interactor.fetchCurrencies()
        
        // then
        XCTAssertTrue(mockCacheManager.getCurrenciesFromLocalCalled)
        XCTAssertTrue(output.fetchedCurrenciesCalled)
        XCTAssertNotEqual(output.currencies.count, mockCacheManager.mockCurrencies?.count)
    }
    
    func testFetchExchangeRatesLessThan30Minute() {
        // given
        let exchangeRate = ExchangeRate(fromCurrency: "USD", toCurrency: "TWD", rate: 28.1)
        mockWebService.mockExchangeRates = [exchangeRate]
        mockCacheManager.mockLastFetchExchangeRateLess30Min = true
        
        // when
        interactor.fetchExchangeRates()
        
        // then
        XCTAssertTrue(mockWebService.fetchExchangeRatesCalled)
        XCTAssertTrue(mockCacheManager.saveExchangeRatesToLocalCalled)
        XCTAssertTrue(output.fetchedExchangeRatesCalled)
        XCTAssertEqual(output.exchangeRates.count, mockWebService.mockExchangeRates.count)
        XCTAssertEqual(output.exchangeRates.first?.fromCurrency, mockWebService.mockExchangeRates.first?.fromCurrency)
        XCTAssertEqual(output.exchangeRates.first?.toCurrency, mockWebService.mockExchangeRates.first?.toCurrency)
        XCTAssertEqual(output.exchangeRates.first?.rate, mockWebService.mockExchangeRates.first?.rate)
    }
    
    func testFetchExchangeRatesLessThan30MinuteGetError() {
        // given
        let error = NSError(domain:"", code:404, userInfo:[ NSLocalizedDescriptionKey: "Can't found page"]) as Error
        mockWebService.fetchExchangeRatesError = error
        mockCacheManager.mockLastFetchExchangeRateLess30Min = true
        
        // when
        interactor.fetchExchangeRates()
        
        // then
        XCTAssertTrue(mockWebService.fetchExchangeRatesCalled)
        XCTAssertFalse(mockCacheManager.saveExchangeRatesToLocalCalled)
        XCTAssertFalse(output.fetchedExchangeRatesCalled)
    }
    
    func testFetchExchangeRatesOverThan30Minute() {
        // given
        let exchangeRate = ExchangeRate(fromCurrency: "USD", toCurrency: "TWD", rate: 28.1)
        mockCacheManager.mockExchangeRates = [exchangeRate]
        mockCacheManager.mockLastFetchExchangeRateLess30Min = false
        
        // when
        interactor.fetchExchangeRates()
        
        // then
        XCTAssertTrue(mockCacheManager.getExchangeRatesFromLocalCalled)
        XCTAssertTrue(output.fetchedExchangeRatesCalled)
        XCTAssertEqual(output.exchangeRates.count, mockCacheManager.mockExchangeRates?.count)
        XCTAssertEqual(output.exchangeRates.first?.fromCurrency, mockCacheManager.mockExchangeRates?.first?.fromCurrency)
        XCTAssertEqual(output.exchangeRates.first?.toCurrency, mockCacheManager.mockExchangeRates?.first?.toCurrency)
        XCTAssertEqual(output.exchangeRates.first?.rate, mockCacheManager.mockExchangeRates?.first?.rate)
    }
    
    func testFetchExchangeRatesOverThan30MinuteDataMiss() {
        // given
        mockCacheManager.mockLastFetchExchangeRateLess30Min = false
        
        // when
        interactor.fetchExchangeRates()
        
        // then
        XCTAssertTrue(mockCacheManager.getExchangeRatesFromLocalCalled)
        XCTAssertTrue(output.fetchedExchangeRatesCalled)
        XCTAssertNotEqual(output.exchangeRates.count, mockCacheManager.mockExchangeRates?.count)
    }
}
