//
//  ConverterGridPresenter.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/12.
//

import Foundation

class ConverterGridPresenter {
    weak var view: ConverterGridViewInput?
    var interactor: ConverterGridInteractorInput?
    var router: ConverterGridRouterInput?
    var currencies: [Currency] = []
    var exchangeRates: [ExchangeRate] = []
}

extension ConverterGridPresenter: ConverterGridViewOutput {
    var exchangeRatesCount: Int {
        return exchangeRates.count
    }
    
    func viewIsReady() {
        interactor?.fetchExchangeRates()
    }

    func tappedCurrencyButton() {
        interactor?.fetchCurrencies()
    }
}

extension ConverterGridPresenter: ConverterGridInteractorOutput {
    func fetchedCurrencies(_ currencies:[Currency]) {
        self.currencies = currencies
    }
    
    func fetchedExchangeRates(_ exchangeRates: [ExchangeRate]) {
        self.exchangeRates = exchangeRates
        view?.exchangeRatesIsReady()
    }
}
