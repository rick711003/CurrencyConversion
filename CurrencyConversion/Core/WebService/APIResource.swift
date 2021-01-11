//
//  APIResource.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/11.
//

//currencyLayer key 489f5607d6bbd7ce0c69c32d157675bc

import Foundation

protocol APIResource {
    var methodPath: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension APIResource {
    var url: URL {
        var components = URLComponents(string: "http://api.currencylayer.com/")!
        components.path = methodPath
        components.queryItems = queryItems
        return components.url!
    }
}
