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
    @IBOutlet weak var exchangeValueLabel: UILabel!
    var cellModel: ExchangeRateCellModel? = nil
    public override func awakeFromNib() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.cornerRadius = 3
    }
    
    func configCell(cellModel: ExchangeRateCellModel?) {
        guard let cellModel = cellModel else {
            return
        }
        self.cellModel = cellModel
        currencyNameLabel.text = cellModel.name
        exchangeValueLabel.text = String(cellModel.amount)
        rateLabel.text = String(cellModel.rate)
    }
}
