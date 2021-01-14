//
//  ConverterGridViewModel.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/13.
//

import Foundation

class ExchangeRateCellModel {
    var fromCurrencyName: String
    var toCurrencyFullName: String
    var toCurrencyShortName: String
    var rate: Double
    var amount: Double
    
    init(fromCurrencyName: String,
         toCurrencyFullName: String,
         toCurrencyShortName: String,
         rate: Double,
         amount: Double) {
        
        self.fromCurrencyName = fromCurrencyName
        self.toCurrencyFullName = toCurrencyFullName
        self.toCurrencyShortName = toCurrencyShortName
        self.rate = rate
        self.amount = amount
    }
    
    func updateAmount(by amount: Double) {
        self.amount = amount
    }
}
