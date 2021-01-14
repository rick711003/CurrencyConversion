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
        let selectedCurrencyExchangeRateObject = exchangeRates.filter { $0.toCurrency ==  selectedCurrency?.shortName }
        if let selectedCurrencyRate = selectedCurrencyExchangeRateObject.first?.rate {
            exchangeRateCellModels = exchangeRates.compactMap {
                if let baseRate = $0.rate, let toCurrency = $0.toCurrency, let selectedCurrency = self.selectedCurrency {
                    if let fromCurrencyShortName = selectedCurrency.shortName,
                        let toCurrencyShortName = toCurrency.isEmpty ? $0.fromCurrency : $0.toCurrency,
                        let toCurrencyFullName = getCurrencyFullName(by: toCurrencyShortName) {
                        let updateBaseRateFromSelectedRate = baseRate / selectedCurrencyRate
                        let updateAmountFromNewRate = currentAmount * updateBaseRateFromSelectedRate
                        return ExchangeRateCellModel(fromCurrencyName: fromCurrencyShortName,
                                                     toCurrencyFullName: toCurrencyFullName,
                                                     toCurrencyShortName: toCurrencyShortName,
                                                     rate: updateBaseRateFromSelectedRate.ceiling(toDecimal: 3),
                                                     amount: updateAmountFromNewRate.ceiling(toDecimal: 3))
                    }
                }
                return nil
            }
            view?.exchangeRatesIsReady()
        }
    }
    
    private func getCurrencyFullName(by shortName: String?) -> String? {
        guard !currencies.isEmpty, let shortName = shortName else {
            return nil
        }
        let targetCurrency = currencies.filter { $0.shortName == shortName }
        return targetCurrency.first?.name
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
        interactor?.fetchCurrencies()
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
        if exchangeRateCellModelsCount > 0 {
           let _ = exchangeRateCellModels.compactMap {
            $0.updateAmount(by: ($0.rate * amount).ceiling(toDecimal: 3))
            }
            view?.exchangeRatesIsReady()
        }
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
            if let baseRate = $0.rate,
               let toCurrency = $0.toCurrency,
               let toCurrencyShortName = toCurrency.isEmpty ? $0.fromCurrency : $0.toCurrency,
               let toCurrencyFullName = getCurrencyFullName(by: toCurrencyShortName) {
                return ExchangeRateCellModel(fromCurrencyName: "USD",
                                             toCurrencyFullName: toCurrencyFullName,
                                             toCurrencyShortName: toCurrencyShortName,
                                             rate: baseRate.ceiling(toDecimal: 3),
                                             amount: 0.0)
            }
            return nil
        }
        view?.exchangeRatesIsReady()
    }
}

extension Double {
    func ceiling(toDecimal decimal: Int) -> Double {
        let numberOfDigits = abs(pow(10.0, Double(decimal)))
        return Double(ceil(self * numberOfDigits)) / numberOfDigits
    }
}
