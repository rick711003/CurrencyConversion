//
//  ExchangeRateCell.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/12.
//

import UIKit

public class ExchangeRateCell: UICollectionViewCell {
    
    private enum Constant {
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 3
    }
    
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var exchangeValueLabel: UILabel!
    @IBOutlet weak var exchangeRuleLabel: UILabel!
    var cellModel: ExchangeRateCellModel? = nil
        
    public override func awakeFromNib() {
        contentView.layer.borderWidth = Constant.borderWidth
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.cornerRadius = Constant.cornerRadius
    }
    
    func configCell(cellModel: ExchangeRateCellModel?) {
        guard let cellModel = cellModel else {
            return
        }
        self.cellModel = cellModel
        currencyNameLabel.text = cellModel.toCurrencyFullName
        exchangeValueLabel.text = String(cellModel.amount)
        exchangeRuleLabel.text = cellModel.fromCurrencyName + " -> " + cellModel.toCurrencyShortName
        rateLabel.text = String(cellModel.rate)
        exchangeValueLabel.textColor = cellModel.amount > 0 ? .red : .gray
    }
}
