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
    init(service: WebService?) {
        self.service = service
    }
}

extension ConverterGridInteractor: ConverterGridInteractorInput {
    func fetchCurrencies() {
        service?.fetchCurrenciesList(completion: { [weak self] (currencies: [Currency]?, error: Error?) in
            guard let currencies = currencies, error == nil else {
                return
            }
            self?.output?.fetchedCurrencies(currencies)
        })
    }
    
    func fetchExchangeRates() {
        service?.fetchExchangeRates(completion: { [weak self] (exchangeRates: [ExchangeRate]?, error: Error?) in
            guard let exchangeRates = exchangeRates, error == nil else {
                return
            }
            self?.output?.fetchedExchangeRates(exchangeRates)
        })
    }
}
