//
//  ConverterGridViewControllerTests.swift
//  CurrencyConversionTests
//
//  Created by Wen Chien Chen on 2021/1/14.
//

import XCTest
@testable import CurrencyConversion

final class ConverterGridViewControllerTests: XCTestCase {
    
    private var presenter: MockConverterGridViewOutput!
    private var viewController: ConverterGridViewController!
    
    override func setUp() {
        super.setUp()
        presenter = MockConverterGridViewOutput()
        viewController = ConverterGridViewController(
            nibName: String(describing: ConverterGridViewController.self),
            bundle: Bundle(for: ConverterGridViewController.self)
        )
        viewController.presenter = presenter
    }

    override func tearDown() {
        presenter = nil
        viewController = nil
        super.tearDown()
    }
    
    func testViewDidLoad() {
        // when
        viewController.loadViewIfNeeded()
        
        // then
        XCTAssertTrue(presenter.viewIsReadyCalled)
        XCTAssertNotNil(viewController.collectionView)
        XCTAssertNotNil(viewController.collectionView.delegate)
        XCTAssertNotNil(viewController.collectionView.dataSource)
        XCTAssertTrue(viewController.view.gestureRecognizers?.count == 1)
    }
    
    func testExchangeRatesIsReadyCellSize() {
        // given
        viewController.loadViewIfNeeded()
        let fittingSize = viewController.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        viewController.view.frame.size = CGSize(width: 375, height: fittingSize.height)
        
        let TWDCurrency = Currency(name: "Taiwan Dollar", shortName: "TWD")
        let USDCurrency = Currency(name: "United States Dollar", shortName: "USD")
        presenter.mockCurrencies = [TWDCurrency, USDCurrency]
        let TWDExchangeRateModel = ExchangeRateCellModel(fromCurrencyName: "USD",
                                                         toCurrencyFullName: "Taiwan Dollar",
                                                         toCurrencyShortName: "TWD",
                                                         rate: 28.1,
                                                         amount: 2810)
        let USDExchangeRateModel = ExchangeRateCellModel(fromCurrencyName: "USD",
                                                         toCurrencyFullName: "United States Dollar",
                                                         toCurrencyShortName: "USD",
                                                         rate: 1,
                                                         amount: 100)
        presenter.mockExchangeRateCellModels = [TWDExchangeRateModel, USDExchangeRateModel]
        
        
        // when
        viewController.exchangeRatesIsReady()
        let itemSize = viewController.collectionView(viewController.collectionView,
                                                     layout: UICollectionViewLayout(),
                                                     sizeForItemAt: IndexPath(item: 0, section: 0))
  
        // then
        XCTAssertTrue(itemSize.width == 117)
        XCTAssertTrue(itemSize.height == 100.0)
    }
    
    func testCurrenciesIsReady() {
        // given
        viewController.loadViewIfNeeded()
        
        let TWDCurrency = Currency(name: "Taiwan Dollar", shortName: "TWD")
        let USDCurrency = Currency(name: "United States Dollar", shortName: "USD")
        presenter.mockCurrencies = [TWDCurrency, USDCurrency]
        let TWDExchangeRateModel = ExchangeRateCellModel(fromCurrencyName: "USD",
                                                         toCurrencyFullName: "Taiwan Dollar",
                                                         toCurrencyShortName: "TWD",
                                                         rate: 28.1,
                                                         amount: 2810)
        let USDExchangeRateModel = ExchangeRateCellModel(fromCurrencyName: "USD",
                                                         toCurrencyFullName: "United States Dollar",
                                                         toCurrencyShortName: "USD",
                                                         rate: 1,
                                                         amount: 100)
        presenter.mockExchangeRateCellModels = [TWDExchangeRateModel, USDExchangeRateModel]
        presenter.mockSelectedCurrency = TWDCurrency
        viewController.viewDidLoad()
        
        // when
        viewController.currenciesIsReady()
        
        // then
        XCTAssertTrue(viewController.pickerView?.accessibilityValue == "TWD")
    }
    
    func testTapCurrencyButton() {
        // given
        viewController.loadViewIfNeeded()
        let sendButton = UIButton()
        
        // when
        viewController.tapCurrencyButton(sendButton)
        
        // then
        XCTAssertTrue(presenter.tappedCurrencyButtonCalled)
    }
    
    func testTextFieldDidEndEditingWithNumber() {
        // given
        viewController.loadViewIfNeeded()
        viewController.amountTextField.text = "100"
        
        // when
        viewController.textFieldDidEndEditing(viewController.amountTextField)
        
        // then
        XCTAssertFalse(viewController.amountTextField.placeholder!.isEmpty)
        XCTAssertEqual(viewController.amountTextField.text, "100")
        XCTAssertTrue(presenter.didChangeAmountCalled)
    }
    
    func testTextFieldDidEndEditingWithString() {
        // given
        viewController.loadViewIfNeeded()
        viewController.amountTextField.text = "AA"
        
        // when
        viewController.textFieldDidEndEditing(viewController.amountTextField)
        
        // then
        XCTAssertFalse(viewController.amountTextField.placeholder!.isEmpty)
        XCTAssertEqual(viewController.amountTextField.text, "AA")
        XCTAssertFalse(presenter.didChangeAmountCalled)
    }
    
    func testTextFieldDidChangeSelectionWithNumber() {
        // given
        viewController.loadViewIfNeeded()
        viewController.amountTextField.text = "100"
        
        // when
        viewController.textFieldDidChangeSelection(viewController.amountTextField)
        
        // then
        XCTAssertFalse(viewController.amountTextField.placeholder!.isEmpty)
        XCTAssertEqual(viewController.amountTextField.text, "100")
        XCTAssertTrue(presenter.didChangeAmountCalled)
    }
    
    func testTextFieldDidChangeSelectionWithString() {
        // given
        viewController.loadViewIfNeeded()
        viewController.amountTextField.text = "AA"
        
        // when
        viewController.textFieldDidChangeSelection(viewController.amountTextField)
        
        // then
        XCTAssertFalse(viewController.amountTextField.placeholder!.isEmpty)
        XCTAssertEqual(viewController.amountTextField.text, "AA")
        XCTAssertFalse(presenter.didChangeAmountCalled)
    }
    
    func testPickerViewDidSelectRowHaveCurrency() {
        // given
        viewController.loadViewIfNeeded()
        let TWDCurrency = Currency(name: "Taiwan Dollar", shortName: "TWD")
        presenter.mockCurrencies = [TWDCurrency]
        
        // when
        viewController.pickerView(UIPickerView(), didSelectRow: 0, inComponent: 0)
        
        // then
        XCTAssertTrue(presenter.didSelectCurrencyCalled)
        XCTAssertEqual(presenter.mockDidSelectCurrency!.name, TWDCurrency.name)
        XCTAssertEqual(presenter.mockDidSelectCurrency!.shortName, TWDCurrency.shortName)
    }
    

    func testUpdateCurrencyButtonTextHaveSelectedCurrency() {
        // given
        viewController.loadViewIfNeeded()
        let TWDCurrency = Currency(name: "Taiwan Dollar", shortName: "TWD")
        presenter.mockSelectedCurrency = TWDCurrency
        
        // when
        viewController.updateCurrencyButtonText()
        
        // then
        XCTAssertTrue(viewController.currencyButton.titleLabel?.text == "TWD")
    }
    
    func testUpdateCurrencyButtonTextNoSelectedCurrency() {
        // when
        viewController.loadViewIfNeeded()
        viewController.updateCurrencyButtonText()
        
        // then
        XCTAssertTrue(viewController.currencyButton.titleLabel?.text == "UNKNOWN")
    }
}
