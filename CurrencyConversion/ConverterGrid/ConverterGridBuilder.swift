//
//  ConverterGridBuilder.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/12.
//

import Foundation

public struct ConverterGridBuilder {
    
    private let service: WebService?
    
    public init() {
        service = WebService(session: URLSession(configuration: .ephemeral,
                                                 delegate: nil,
                                                 delegateQueue: .main))
    }
    
    public func build() -> ConverterGridViewController {
        let nibName = String(describing: ConverterGridViewController.self)
        let viewController = ConverterGridViewController(nibName: nibName, bundle: .main)
        
        let router = ConverterGridRouter()
        router.viewController = viewController
        
        let presenter = ConverterGridPresenter()
        presenter.view = viewController
        presenter.router = router
        
        let interactor = ConverterGridInteractor(service: service)
        interactor.output = presenter
        presenter.interactor = interactor
        
        viewController.output = presenter
        return viewController
    }
}
