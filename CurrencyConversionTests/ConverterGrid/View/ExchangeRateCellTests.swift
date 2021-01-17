//
//  ExchangeRateCellTests.swift
//  CurrencyConversionTests
//
//  Created by Wen Chien Chen on 2021/1/17.
//

import XCTest
@testable import CurrencyConversion

final class ExchangeRateCellTests: XCTestCase {
    
    var exchangeRateCell: ExchangeRateCell!
    override func setUp() {
        super.setUp()
        exchangeRateCell = Bundle.main.loadNibNamed(String(describing: ExchangeRateCell.self),
                                                    owner: nil, options: nil)?.first as? ExchangeRateCell
    }
    
    override func tearDown() {
        exchangeRateCell = nil
        super.tearDown()
    }
    
    func testConfigCellHaveModel() {
        // given
        let exchangeRateCellModel = ExchangeRateCellModel(fromCurrencyName: "USD",
                                                          toCurrencyFullName: "Taiwan Dollar",
                                                          toCurrencyShortName: "TWD",
                                                          rate: 28.1,
                                                          amount: 100)
        
        // when
        exchangeRateCell.configCell(cellModel: exchangeRateCellModel)
        
        // then
        XCTAssertTrue(exchangeRateCell.currencyNameLabel!.text == "Taiwan Dollar")
        XCTAssertTrue(exchangeRateCell.rateLabel!.text == "28.1")
        XCTAssertTrue(exchangeRateCell.exchangeValueLabel!.text == "100.0")
        XCTAssertTrue(exchangeRateCell.exchangeRuleLabel!.text == "USD -> TWD")
        
    }
    
    func testConfigCellNoModel() {
        // when
        exchangeRateCell.configCell(cellModel: nil)
        
        // then
        XCTAssertTrue(exchangeRateCell.currencyNameLabel!.text == "Label")
        XCTAssertTrue(exchangeRateCell.rateLabel!.text == "Label")
        XCTAssertTrue(exchangeRateCell.exchangeValueLabel!.text == "...")
        XCTAssertTrue(exchangeRateCell.exchangeRuleLabel!.text == "Label")
    }
}
