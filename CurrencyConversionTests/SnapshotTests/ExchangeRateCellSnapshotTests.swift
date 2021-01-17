//
//  ExchangeRateCellSnapshotTests.swift
//  CurrencyConversionTests
//
//  Created by Wen Chien Chen on 2021/1/17.
//

import XCTest
import FBSnapshotTestCase
@testable import CurrencyConversion

final class ExchangeRateCellSnapshotTests: FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        self.recordMode = false
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testNilDefault() {
        let cell = UINib(nibName: "ExchangeRateCell", bundle: nil).instantiate(withOwner: nil,
                                                                           options: nil)[0] as! ExchangeRateCell
        cell.configCell(cellModel: nil)
        
        verifyView(cell)
    }
    
    func testDefault() {
        let TWDExchangeRateModel = ExchangeRateCellModel(fromCurrencyName: "USD",
                                                         toCurrencyFullName: "Taiwan Dollar",
                                                         toCurrencyShortName: "TWD",
                                                         rate: 28.1,
                                                         amount: 2810)
        let cell = UINib(nibName: "ExchangeRateCell", bundle: nil).instantiate(withOwner: nil,
                                                                           options: nil)[0] as! ExchangeRateCell
        cell.configCell(cellModel: TWDExchangeRateModel)
        
        verifyView(cell)
    }
}

extension FBSnapshotTestCase {
    
    func verifyView(_ cell: UICollectionViewCell) {
        cell.contentView.setNeedsUpdateConstraints()
        cell.contentView.updateConstraintsIfNeeded()
        
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        
        cell.frame.size = CGSize(width: 117, height: 100)
        FBSnapshotVerifyView(cell)
    }
    
}

