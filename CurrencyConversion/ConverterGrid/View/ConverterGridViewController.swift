//
//  ConverterGridViewController.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/12.
//

import UIKit

public class ConverterGridViewController: UIViewController {
    var output: ConverterGridViewOutput?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyButton: UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "ExchangeRateCell", bundle: nil),
                                forCellWithReuseIdentifier: "ExchangeRateCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension ConverterGridViewController: ConverterGridViewInput {
    
}

// UICollectionViewDataSource

extension ConverterGridViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                                cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExchangeRateCell", for: indexPath)
        
        return cell
    }
}

// UICollectionViewDelegate

extension ConverterGridViewController: UICollectionViewDelegate {

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
