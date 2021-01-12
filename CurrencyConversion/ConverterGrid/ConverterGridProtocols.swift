//
//  ConverterGridProtocols.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/12.
//

import Foundation

protocol ConverterGridViewInput: class {
    func exchangeRatesIsReady()
}

protocol ConverterGridViewOutput {
    var exchangeRatesCount: Int { get }
    var exchangeRates: [ExchangeRate] { get }

    func viewIsReady()
    func tappedCurrencyButton()
}

protocol ConverterGridInteractorInput {
    func fetchCurrencies()
    func fetchExchangeRates()
}

protocol ConverterGridInteractorOutput: class {
    func fetchedCurrencies(_ currencies: [Currency])
    func fetchedExchangeRates(_ exchangeRates: [ExchangeRate])
}

protocol ConverterGridRouterInput {
    
}
