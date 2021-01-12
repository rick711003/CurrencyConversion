//
//  ConverterGridInteractor.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/12.
//

import Foundation

class ConverterGridInteractor {
    weak var output: ConverterGridInteractorOutput?
    let service: WebService?
    init(service: WebService?) {
        self.service = service
    }
}

extension ConverterGridInteractor: ConverterGridInteractorInput {
    
}
