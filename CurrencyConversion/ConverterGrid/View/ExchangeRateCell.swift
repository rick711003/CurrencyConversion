//
//  ExchangeRateCell.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/12.
//

import UIKit

public class ExchangeRateCell: UICollectionViewCell {
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    public override func awakeFromNib() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.green.cgColor
        contentView.layer.cornerRadius = 3
    }
}