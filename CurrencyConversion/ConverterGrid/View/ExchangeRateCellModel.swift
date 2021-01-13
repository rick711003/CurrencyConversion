//
//  ConverterGridViewModel.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/13.
//

import Foundation

class ExchangeRateCellModel {
    var name: String
    var rate: Double
    var amount: Double
    
    init(name: String, rate: Double, amount: Double) {
        self.name = name
        self.rate = rate
        self.amount = amount
    }
    
    func updateAmount(by amount: Double) {
        self.amount = amount
    }
}
