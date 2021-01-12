//
//  ConverterGridPresenter.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/12.
//

import Foundation

class ConverterGridPresenter {
    weak var view: ConverterGridViewInput?
    var interactor: ConverterGridInteractorInput?
    var router: ConverterGridRouterInput?
}

extension ConverterGridPresenter: ConverterGridViewOutput {
    func viewIsReady() {
    }
}

extension ConverterGridPresenter: ConverterGridInteractorOutput {
    
}
