//
//  CacheManager.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/13.
//

import Foundation

class CacheManager {
    let userDefaults = UserDefaults.standard
    func saveExchangeRatesToLocal(exchangeRates: [ExchangeRate]) {
        guard !exchangeRates.isEmpty else {
            return
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(exchangeRates) {
            userDefaults.set(encoded, forKey: "exchangeRates")
        }
        userDefaults.setValue(NSDate(), forKey: "lastFetchExchangeRateTime")
        userDefaults.synchronize()
    }
    
    func getExchangeRatesFromLocal() -> [ExchangeRate]? {
        if let exchangeRatesData = userDefaults.object(forKey: "exchangeRates") as? Data {
            let decoder = JSONDecoder()
            if let exchangeRates = try? decoder.decode(Array<ExchangeRate>.self, from: exchangeRatesData) {
                return exchangeRates
            }
        }
        return nil
    }
    
    func lastFetchExchangeRateOver30Min() -> Bool {
        guard let previousSaveTime = userDefaults.value(forKey: "lastFetchExchangeRateTime") as? Date else {
            return true
        }
        let now = NSDate().timeIntervalSince1970
        return (now - previousSaveTime.timeIntervalSince1970) > 1800
    }
    
    func saveCurrenciesToLocal(currencies: [Currency]) {
        guard !currencies.isEmpty else {
            return
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(currencies) {
            userDefaults.set(encoded, forKey: "currencies")
        }
        userDefaults.setValue(NSDate(), forKey: "lastFetchCurrenciesTime")
        userDefaults.synchronize()
    }
    
    func getCurrenciesFromLocal() -> [Currency]? {
        if let currenciesData = userDefaults.object(forKey: "currencies") as? Data {
            let decoder = JSONDecoder()
            if let currencies = try? decoder.decode(Array<Currency>.self, from: currenciesData) {
                return currencies
            }
        }
        return nil
    }
    
    func lastFetchCurrenciesOver30Min() -> Bool {
        guard let previousSaveTime = userDefaults.value(forKey: "lastFetchCurrenciesTime") as? Date else {
            return true
        }
        let now = NSDate().timeIntervalSince1970
        return (now - previousSaveTime.timeIntervalSince1970) > 1800
    }
}
