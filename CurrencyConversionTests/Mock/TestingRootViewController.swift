//
//  TestingRootViewController.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/17.
//

import UIKit

class TestingRootViewController: UIViewController {

    override func loadView() {
        let label = UILabel()
        label.text = "Running Unit Tests..."
        label.textAlignment = .center
        label.textColor = .white

        view = label
    }
}
