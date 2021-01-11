//
//  ConversionRequest.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/11.
//

import Foundation

class ExchangeRateRequest: APIResource {
    let methodPath = "/live"
    let queryItems : [URLQueryItem]
    let session: URLSession
    init(queryItems: [URLQueryItem], session: URLSession) {
        self.queryItems = queryItems
        self.session = session
    }
}

extension ExchangeRateRequest: APIRequest {
    typealias ModelType = [ExchangeRate]
    func decode(_ data: Data) -> [ExchangeRate]? {
        if let jsonObject = (try? JSONSerialization.jsonObject(with: data, options: [])) ,
           let json = jsonObject as? Dictionary<String, Any>,
           let exchangeRatesFromJSON = json["quotes"] as? Dictionary<String, Any> {
            var exchangeRates: [ExchangeRate] = []
            for exchangeRateFromDictionary in exchangeRatesFromJSON {
                guard let rate = exchangeRateFromDictionary.value as? Double,
                      let fromCurrency = json["source"] as? String else {
                    continue
                }
                let toCurrency = exchangeRateFromDictionary.key.replace(target: fromCurrency, withString: "")
                exchangeRates.append(ExchangeRate(fromCurrency: fromCurrency, toCurrency: toCurrency, rate: rate))
            }
            return exchangeRates
        }
        return nil
    }
    
    func load(withCompletion completion: @escaping ([ExchangeRate]?, Error?) -> Void) {
        load(url, session, withCompletion: completion)
    }
}


extension String{
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target,
                                         with: withString,
                                         options: NSString.CompareOptions.literal,
                                         range: nil)
    }
}
