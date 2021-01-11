//
//  CurrencyRequest.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/11.
//

import Foundation

class CurrencyRequest: APIResource {
    let methodPath = "/list"
    let queryItems : [URLQueryItem]
    let session: URLSession
    init(queryItems: [URLQueryItem], session: URLSession) {
        self.queryItems = queryItems
        self.session = session
    }
}

extension CurrencyRequest: APIRequest {
    typealias ModelType = [Currency]
    func decode(_ data: Data) -> [Currency]? {
        if let jsonObject = (try? JSONSerialization.jsonObject(with: data, options: [])) ,
           let json = jsonObject as? Dictionary<String, Any>,
           // move out currencies
           let currenciesFromJSON = json["currencies"] as? Dictionary<String, Any> {
            var currencies: [Currency] = []
            for currencyFromDictionary in currenciesFromJSON {
                guard let name = currencyFromDictionary.value as? String else {
                    continue
                }
                currencies.append(Currency(name: name, shotName: currencyFromDictionary.key))
            }
            return currencies
        }
        return nil
    }
    
    func load(withCompletion completion: @escaping ([Currency]?, Error?) -> Void) {
        load(url, session, withCompletion: completion)
    }
}
