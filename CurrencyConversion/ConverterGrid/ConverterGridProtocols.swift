//
//  ConverterGridProtocols.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/12.
//

import Foundation

protocol ConverterGridViewInput: class {
    func exchangeRatesIsReady()
    func currenciesIsReady()
    func updateCurrencyButtonText()
}

protocol ConverterGridViewOutput {
    var exchangeRateCellModels: [ExchangeRateCellModel] { get }
    var currencies: [Currency] { get }
    var selectedCurrency: Currency? { get }

    func viewIsReady()
    func tappedCurrencyButton()
    func didSelectCurrency(with currency: Currency)
    func didChangeAmount(with amount: Double)
}

protocol ConverterGridInteractorInput {
    func fetchCurrencies()
    func fetchExchangeRates()
}

protocol ConverterGridInteractorOutput: class {
    func fetchedCurrencies(_ currencies: [Currency])
    func fetchedExchangeRates(_ exchangeRates: [ExchangeRate])
}

protocol ConverterGridRouterInput {}
