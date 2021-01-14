//
//  ConverterGridInteractor.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/12.
//

import Foundation

class ConverterGridInteractor {
    weak var output: ConverterGridInteractorOutput?
    let service: WebService?
    let cacheManager: CacheManager
    init(service: WebService?, cacheManager: CacheManager) {
        self.service = service
        self.cacheManager = cacheManager
    }
}

extension ConverterGridInteractor: ConverterGridInteractorInput {
    func fetchCurrencies() {
        if cacheManager.lastFetchCurrenciesOver30Minute() {
            service?.fetchCurrenciesList(completion: { [weak self] (currencies: [Currency]?, error: Error?) in
                guard let currencies = currencies, error == nil else {
                    return
                }
                self?.cacheManager.saveCurrenciesToLocal(currencies: currencies)
                self?.output?.fetchedCurrencies(currencies)
            })
        } else {
            self.output?.fetchedCurrencies(cacheManager.getCurrenciesFromLocal() ?? [])
        }
    }
    
    func fetchExchangeRates() {
        if cacheManager.lastFetchExchangeRateOver30Minute() {
            service?.fetchExchangeRates(completion: { [weak self] (exchangeRates: [ExchangeRate]?, error: Error?) in
                guard let exchangeRates = exchangeRates, error == nil else {
                    return
                }
                self?.cacheManager.saveExchangeRatesToLocal(exchangeRates: exchangeRates)
                self?.output?.fetchedExchangeRates(exchangeRates)
            })
        } else {
            self.output?.fetchedExchangeRates(cacheManager.getExchangeRatesFromLocal() ?? [])
        }
    }
}
