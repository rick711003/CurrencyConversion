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
    var selectedCurrency: Currency?
    var exchangeRateCellModels: [ExchangeRateCellModel] = []
    var currentAmount: Double = 0.0
    
    private func updateCurrentCurrencyExchangeRate() {
        let exchangeRateObject = exchangeRates.filter { $0.toCurrency ==  selectedCurrency?.shortName }
        if let currentRate = exchangeRateObject.first?.rate {
            exchangeRateCellModels = exchangeRates.compactMap {
                let newRate = ($0.rate ?? 0.0) / currentRate
                let newAmount = (currentAmount != 0) ? currentAmount * newRate : 0.0
                return ExchangeRateCellModel(name: ($0.toCurrency ?? $0.fromCurrency) ?? "",
                                             rate: newRate.ceiling(toDecimal: 3),
                                             amount: newAmount.ceiling(toDecimal: 3))
            }
            view?.exchangeRatesIsReady()
        }
    }
}

extension ConverterGridPresenter: ConverterGridViewOutput {
    var exchangeRateCellModelsCount: Int {
        return exchangeRateCellModels.count
    }
    
    var currenciesCount: Int {
        return exchangeRates.count
    }
    
    func viewIsReady() {
        interactor?.fetchExchangeRates()
    }

    func tappedCurrencyButton() {
        interactor?.fetchCurrencies()
    }
    
    func didSelectCurrency(with currency: Currency) {
        self.selectedCurrency = currency
        updateCurrentCurrencyExchangeRate()
        view?.updateCurrencyButtonText()
    }
    
    func didChangeAmount(with amount: Double) {
        currentAmount = amount
        if exchangeRateCellModels.count > 0 {
           let _ = exchangeRateCellModels.compactMap {
            $0.updateAmount(by: ($0.rate * amount).ceiling(toDecimal: 3))
            }
        }
        view?.exchangeRatesIsReady()
    }
}

extension ConverterGridPresenter: ConverterGridInteractorOutput {
    func fetchedCurrencies(_ currencies:[Currency]) {
        self.currencies = currencies
        view?.currenciesIsReady()
    }
    
    func fetchedExchangeRates(_ exchangeRates: [ExchangeRate]) {
        self.exchangeRates = exchangeRates
        exchangeRateCellModels = exchangeRates.compactMap {
            return ExchangeRateCellModel(name: ($0.toCurrency ?? $0.fromCurrency) ?? "",
                                         rate: ($0.rate ?? 0.0).ceiling(toDecimal: 3),
                                         amount: 0.0)
        }
        view?.exchangeRatesIsReady()
    }
}

extension Double {
    func ceiling(toDecimal decimal: Int) -> Double {
        let numberOfDigits = abs(pow(10.0, Double(decimal)))
        if self.sign == .minus {
            return Double(Int(self * numberOfDigits)) / numberOfDigits
        } else {
            return Double(ceil(self * numberOfDigits)) / numberOfDigits
        }
    }
}
