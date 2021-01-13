//
//  ExchangeRate.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/11.
//

import Foundation

struct ExchangeRate: Codable {
    let fromCurrency: String?
    let toCurrency: String?
    let rate: Double?
}
