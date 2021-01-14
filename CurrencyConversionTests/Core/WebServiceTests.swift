//
//  WebServiceTests.swift
//  CurrencyConversionTests
//
//  Created by Wen Chien Chen on 2021/1/14.
//

import XCTest
@testable import CurrencyConversion

final class WebServiceTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchCurrenciesListSuccess() {
        let webService = WebService(session: URLSession(configuration: .ephemeral,
                                                        delegate: nil,
                                                        delegateQueue: .main))
        let expectation = self.expectation(description: "Get data failing")
        
        webService.fetchCurrenciesList { (currencies: [Currency]?, error: Error?) in
            XCTAssertNil(error)
            XCTAssertNotNil(currencies)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }
    
    func testFetchExchangeRatesSuccess() {
        let webService = WebService(session: URLSession(configuration: .ephemeral,
                                                        delegate: nil,
                                                        delegateQueue: .main))
        let expectation = self.expectation(description: "Get data failing")
        
        webService.fetchExchangeRates { (exchangeRates: [ExchangeRate]?, error: Error?) in
            XCTAssertNil(error)
            XCTAssertNotNil(exchangeRates)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }
    
    func testFetchCurrenciesListError() {
        let error = NSError(domain: "error", code: 1234, userInfo: nil)
        let mockURLSession  = MockURLSession(data: nil, urlResponse: nil, error: error)
        let webService = WebService(session: mockURLSession)
        let expectation = self.expectation(description: "Get data failing")

        //when
        webService.fetchCurrenciesList { (currencies: [Currency]?, error: Error?) in
            XCTAssertNotNil(error)
            XCTAssertNil(currencies)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }
    
    func testFetchExchangeRatesError() {
        let error = NSError(domain: "error", code: 1234, userInfo: nil)
        let mockURLSession  = MockURLSession(data: nil, urlResponse: nil, error: error)
        let webService = WebService(session: mockURLSession)
        let expectation = self.expectation(description: "Get data failing")

        //when
        webService.fetchExchangeRates { (exchangeRates: [ExchangeRate]?, error: Error?) in
            XCTAssertNotNil(error)
            XCTAssertNil(exchangeRates)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }
}
