//
//  CacheManager.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/13.
//

import Foundation

class CacheManager {
    
    private enum Constant {
        static let exchangeRates = "exchangeRates"
        static let currencies = "currencies"
        static let lastFetchExchangeRateTime = "lastFetchExchangeRateTime"
        static let lastFetchCurrenciesTime = "lastFetchCurrenciesTime"
        static let secondsOf30Minute: Double = 30 * 60
    }
    
    let userDefaults = UserDefaults.standard
    
    func saveExchangeRatesToLocal(exchangeRates: [ExchangeRate]) {
        guard !exchangeRates.isEmpty else {
            return
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(exchangeRates) {
            userDefaults.set(encoded, forKey: Constant.exchangeRates)
        }
        userDefaults.setValue(NSDate(), forKey: Constant.lastFetchExchangeRateTime)
        userDefaults.synchronize()
    }
    
    func getExchangeRatesFromLocal() -> [ExchangeRate]? {
        if let exchangeRatesData = userDefaults.object(forKey: Constant.exchangeRates) as? Data {
            let decoder = JSONDecoder()
            if let exchangeRates = try? decoder.decode(Array<ExchangeRate>.self, from: exchangeRatesData) {
                return exchangeRates
            }
        }
        return nil
    }
    
    func lastFetchExchangeRateOver30Minute() -> Bool {
        guard let previousSaveTime = userDefaults.value(forKey: Constant.lastFetchExchangeRateTime) as? Date else {
            return true
        }
        let now = NSDate().timeIntervalSince1970
        return (now - previousSaveTime.timeIntervalSince1970) > Constant.secondsOf30Minute
    }
    
    func saveCurrenciesToLocal(currencies: [Currency]) {
        guard !currencies.isEmpty else {
            return
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(currencies) {
            userDefaults.set(encoded, forKey: Constant.currencies)
        }
        userDefaults.setValue(NSDate(), forKey: Constant.lastFetchCurrenciesTime)
        userDefaults.synchronize()
    }
    
    func getCurrenciesFromLocal() -> [Currency]? {
        if let currenciesData = userDefaults.object(forKey: Constant.currencies) as? Data {
            let decoder = JSONDecoder()
            if let currencies = try? decoder.decode(Array<Currency>.self, from: currenciesData) {
                return currencies
            }
        }
        return nil
    }
    
    func lastFetchCurrenciesOver30Minute() -> Bool {
        guard let previousSaveTime = userDefaults.value(forKey: Constant.lastFetchCurrenciesTime) as? Date else {
            return true
        }
        let now = NSDate().timeIntervalSince1970
        return (now - previousSaveTime.timeIntervalSince1970) > Constant.secondsOf30Minute
    }
}
