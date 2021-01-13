//
//  WebService.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/11.
//

import Foundation

public class WebService {

    private var currencyRequest: CurrencyRequest?
    private var exchangeRatesRequest: ExchangeRateRequest?
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func fetchCurrenciesList(completion: @escaping (_ modelType: [Currency]?, _ error: Error?) -> Void) {
        let tmpCurrencyRequest = CurrencyRequest(session: session)
        currencyRequest = tmpCurrencyRequest
        tmpCurrencyRequest.load { (currencies: [Currency]?, error: Error?) in
            guard let currencies = currencies, error == nil else {
                completion(nil, error)
                return
            }
            completion(currencies, nil)
        }
    }
    
    func fetchExchangeRates(completion: @escaping (_ modelType: [ExchangeRate]?, _ error: Error?) -> Void) {
        let queryItems = [URLQueryItem(name: "format", value:"1")]
        let tmpExchangeRatesRequest = ExchangeRateRequest(queryItems: queryItems, session: session)
        exchangeRatesRequest = tmpExchangeRatesRequest
        tmpExchangeRatesRequest.load { (exchangeRates: [ExchangeRate]?, error: Error?) in
            guard let exchangeRates = exchangeRates, error == nil else {
                completion(nil, error)
                return
            }
            completion(exchangeRates, nil)
        }
    }
}
