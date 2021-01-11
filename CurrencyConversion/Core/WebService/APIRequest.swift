//
//  APIRequest.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/11.
//

import Foundation

protocol APIRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    func load(withCompletion completion: @escaping (_ modelType: ModelType?, _ error: Error?) -> Void)
}

extension APIRequest {
    func load(_ url: URL,
              _ session: URLSession,
              withCompletion completion: @escaping (_ modelType:ModelType?, _ error: Error? ) -> Void) {
        let task = session.dataTask(with: url, completionHandler: { [weak self] (data: Data?,
                                                                                 response: URLResponse?,
                                                                                 error: Error?) -> Void in
            guard let data = data else {
                completion(nil, error)
                return
            }
            completion(self?.decode(data), nil)
        })
        task.resume()
    }
}
