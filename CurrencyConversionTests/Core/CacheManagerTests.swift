//
//  CacheManagerTests.swift
//  CurrencyConversionTests
//
//  Created by Wen Chien Chen on 2021/1/14.
//

import XCTest
@testable import CurrencyConversion

final class CacheManagerTests: XCTestCase {
    
    private enum Constant {
        static let exchangeRates = "exchangeRates"
        static let currencies = "currencies"
        static let lastFetchExchangeRateTime = "lastFetchExchangeRateTime"
        static let lastFetchCurrenciesTime = "lastFetchCurrenciesTime"
    }
    
    var cacheManager: CacheManager!
    let defaults = UserDefaults.standard
   
    override func setUp() {
        super.setUp()
        clearTestMockData()
        cacheManager = CacheManager()
    }

    override func tearDown() {
        cacheManager = nil
        super.tearDown()
    }
    
    func testSaveExchangeRatesToLocal() {
        // given
        let exchangeRate = ExchangeRate(fromCurrency: "USD", toCurrency: "TWD", rate: 28.1)
        
        // when
        cacheManager.saveExchangeRatesToLocal(exchangeRates: [exchangeRate])
        
        // then
        guard let localExchangeRates = cacheManager.getExchangeRatesFromLocal() else {
            XCTFail(" Did't success save to UserDefaults")
            return
        }
        XCTAssertTrue(localExchangeRates.count == 1)
        XCTAssertEqual(localExchangeRates.first?.fromCurrency, "USD")
        XCTAssertEqual(localExchangeRates.first?.toCurrency, "TWD")
        XCTAssertEqual(localExchangeRates.first?.rate, 28.1)
    }
    
    func testSaveExchangeRatesToLocalWithEmpty() {
        // when
        cacheManager.saveExchangeRatesToLocal(exchangeRates: [])
        
        // then
        XCTAssertNil(cacheManager.getExchangeRatesFromLocal())
    }
    
    func testLastFetchExchangeRateOver30Minute() {
        // given
        let over30Minute = NSDate(timeIntervalSinceNow: -30 * 60)
        let exchangeRate = ExchangeRate(fromCurrency: "USD", toCurrency: "TWD", rate: 28.1)
        cacheManager.saveExchangeRatesToLocal(exchangeRates: [exchangeRate])
        defaults.setValue(over30Minute, forKey: Constant.lastFetchExchangeRateTime)
        
        // when
        let result = cacheManager.lastFetchExchangeRateOver30Minute()
        
        // then
        XCTAssertTrue(result)
    }
    
    func testLastFetchExchangeRateLess30Minute() {
        // given
        let exchangeRate = ExchangeRate(fromCurrency: "USD", toCurrency: "TWD", rate: 28.1)
        cacheManager.saveExchangeRatesToLocal(exchangeRates: [exchangeRate])
        
        // when
        let result = cacheManager.lastFetchExchangeRateOver30Minute()
        
        // then
        XCTAssertFalse(result)
    }
    
    func testLastFetchExchangeRateNeverSaveExchangeRate() {
        // when
        let result = cacheManager.lastFetchExchangeRateOver30Minute()
        
        // then
        XCTAssertTrue(result)
    }
    
    func testSaveCurrenciesToLocal() {
        // given
        let TWDCurrency = Currency(name: "Taiwan Dollar", shortName: "TWD")
        
        // when
        cacheManager.saveCurrenciesToLocal(currencies: [TWDCurrency])
        
        // then
        guard let currencies = cacheManager.getCurrenciesFromLocal() else {
            XCTFail(" Did't success save to UserDefaults")
            return
        }
        XCTAssertTrue(currencies.count == 1)
        XCTAssertEqual(currencies.first?.name, "Taiwan Dollar")
        XCTAssertEqual(currencies.first?.shortName, "TWD")
    }
    
    func testSaveCurrenciesToLocalWithEmpty() {
        // when
        cacheManager.saveCurrenciesToLocal(currencies: [])
        
        // then
        XCTAssertNil(cacheManager.getCurrenciesFromLocal())
    }
    
    func testLastFetchCurrenciesOver30Minute() {
        // given
        let over30Minute = NSDate(timeIntervalSinceNow: -30 * 60)
        let TWDCurrency = Currency(name: "Taiwan Dollar", shortName: "TWD")
        cacheManager.saveCurrenciesToLocal(currencies: [TWDCurrency])
        defaults.setValue(over30Minute, forKey: Constant.lastFetchCurrenciesTime)
        
        // when
        let result = cacheManager.lastFetchCurrenciesOver30Minute()
        
        // then
        XCTAssertTrue(result)
    }
    
    func testLastFetchCurrenciesLess30Minute() {
        // given
        let TWDCurrency = Currency(name: "Taiwan Dollar", shortName: "TWD")
        cacheManager.saveCurrenciesToLocal(currencies: [TWDCurrency])
        
        // when
        let result = cacheManager.lastFetchCurrenciesOver30Minute()
        
        // then
        XCTAssertFalse(result)
    }
    
    func testLastFetchCurrenciesNeverSaveData() {
        // when
        let result = cacheManager.lastFetchCurrenciesOver30Minute()
        
        // then
        XCTAssertTrue(result)
    }
    
    private func clearTestMockData() {
        defaults.removeObject(forKey: Constant.exchangeRates)
        defaults.removeObject(forKey: Constant.currencies)
        defaults.removeObject(forKey: Constant.lastFetchExchangeRateTime)
        defaults.removeObject(forKey: Constant.lastFetchCurrenciesTime)
    }
}
