//
//  ConverterGridViewController.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/12.
//

import UIKit

public class ConverterGridViewController: UIViewController {
    var presenter: ConverterGridViewOutput?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyButton: UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "ExchangeRateCell", bundle: nil),
                                forCellWithReuseIdentifier: "ExchangeRateCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        presenter?.viewIsReady()
    }
    
    @IBAction func tapCurrencyButton(_ sender: UIButton) {
        presenter?.tappedCurrencyButton()
    }
}

extension ConverterGridViewController: ConverterGridViewInput {
    func exchangeRatesIsReady() {
        collectionView.reloadData()
    }
}

// UICollectionViewDataSource

extension ConverterGridViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.exchangeRatesCount ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                                cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExchangeRateCell", for: indexPath)
        if let exchangeRateCell = cell as? ExchangeRateCell {
            exchangeRateCell.configCell(cellModel: presenter?.exchangeRates[indexPath.row])
        }
        return cell
    }
}

// UICollectionViewDelegateFlowLayout

extension ConverterGridViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (self.view.bounds.width - 20) / 3
        return CGSize(width: cellWidth, height: 100.0)
    }
}
