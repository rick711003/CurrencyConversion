//
//  ConverterGridBuilderTests.swift
//  CurrencyConversionTests
//
//  Created by Wen Chien Chen on 2021/1/14.
//

import XCTest
@testable import CurrencyConversion

final class ConverterGridBuilderTests: XCTestCase {

    private var builder: ConverterGridBuilder!

    override func setUp() {
        super.setUp()
        builder = ConverterGridBuilder()
    }

    override func tearDown() {
        builder = nil
        super.tearDown()
    }

    func testBuildForConverterGrid() {
        // when
        let converterGridViewController = builder.build()
        
        // then
        XCTAssertTrue(converterGridViewController.isKind(of: ConverterGridViewController.self))
        XCTAssertTrue(converterGridViewController.presenter is ConverterGridPresenter)
    }
}

