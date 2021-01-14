//
//  ConverterGridViewController.swift
//  CurrencyConversion
//
//  Created by Wen Chien Chen on 2021/1/12.
//

import UIKit

public class ConverterGridViewController: UIViewController {
    
    private enum Constant {
        static let alertButtonTitle = "Close"
        static let defaultCurrencyShortName = "USD"
        static let exchangeRateCell = "ExchangeRateCell"
        static let pickerTitle = "Select Currency"
        static let unknownCurrencyShortName = "UNKNOWN"
        static let alertHeight: CGFloat = 370
        static let exchangeRateCellHeight: CGFloat = 100.0
        static let exchangeRateCellRowTotalPadding: CGFloat = 24
        static let maximumCells: CGFloat = 3
        static let pickerTopPadding: CGFloat = 45
        static let pickerEdgePadding: CGFloat = 10
        static let pickerHeight: CGFloat = 250
    }
    
    var presenter: ConverterGridViewOutput?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyButton: UIButton!
    private var pickerView: UIPickerView?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: Constant.exchangeRateCell, bundle: nil),
                                forCellWithReuseIdentifier: Constant.exchangeRateCell)
        collectionView.delegate = self
        collectionView.dataSource = self
        amountTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
        view.addGestureRecognizer(tapGesture)
        presenter?.viewIsReady()
    }
    
    @IBAction func tapCurrencyButton(_ sender: UIButton) {
        presenter?.tappedCurrencyButton()
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        amountTextField.resignFirstResponder()
    }
    
    private func showCurrencyPickerView() {
        let alertController = UIAlertController(title: Constant.pickerTitle,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let currencyPicker = UIPickerView()
        alertController.view.addSubview(currencyPicker)
        currencyPicker.translatesAutoresizingMaskIntoConstraints = false
        currencyPicker.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: Constant.pickerTopPadding).isActive = true
        currencyPicker.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -Constant.pickerEdgePadding).isActive = true
        currencyPicker.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: Constant.pickerEdgePadding).isActive = true
        currencyPicker.heightAnchor.constraint(equalToConstant: Constant.pickerHeight).isActive = true
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        alertController.view.translatesAutoresizingMaskIntoConstraints = false
        alertController.view.heightAnchor.constraint(equalToConstant: Constant.alertHeight).isActive = true

        currencyPicker.backgroundColor = .clear
        pickerView = currencyPicker
        setCurrencyPickerDefaultValue(with: currencyPicker)
        
        let cancelAction = UIAlertAction(title: Constant.alertButtonTitle, style: .default, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func setCurrencyPickerDefaultValue(with picker: UIPickerView) {
        var defaultIndex = 0
        if let currentSelectedCurrency = presenter?.selectedCurrency {
            defaultIndex = presenter?.currencies.firstIndex { $0.shortName == currentSelectedCurrency.shortName } ?? 0
        } else {
            defaultIndex = presenter?.currencies.firstIndex { $0.shortName == Constant.defaultCurrencyShortName} ?? 0
        }
        picker.selectRow(defaultIndex, inComponent: 0, animated: true)
    }
}

extension ConverterGridViewController: ConverterGridViewInput {
    func exchangeRatesIsReady() {
        collectionView.reloadData()
    }
    
    func currenciesIsReady() {
        showCurrencyPickerView()
    }
    
    func updateCurrencyButtonText() {
        currencyButton.setTitle(presenter?.selectedCurrency?.shortName ?? Constant.unknownCurrencyShortName,
                                for: .normal)
    }
}

// UICollectionViewDataSource

extension ConverterGridViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.exchangeRateCellModelsCount ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                                cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.exchangeRateCell, for: indexPath)
        if let exchangeRateCell = cell as? ExchangeRateCell {
            exchangeRateCell.configCell(cellModel: presenter?.exchangeRateCellModels[indexPath.row])
        }
        return cell
    }
}

// UICollectionViewDelegateFlowLayout

extension ConverterGridViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (self.view.bounds.width - Constant.exchangeRateCellRowTotalPadding) / Constant.maximumCells
        return CGSize(width: cellWidth, height: Constant.exchangeRateCellHeight)
    }
}

// UIPickerViewDataSource

extension ConverterGridViewController: UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter?.currenciesCount ?? 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return presenter?.currencies[row].name
    }
}

// UIPickerViewDelegate

extension ConverterGridViewController: UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let currency = presenter?.currencies[row] else {
            return
        }
        presenter?.didSelectCurrency(with: currency)
    }
}

// UITextFieldDelegate

extension ConverterGridViewController: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        let amount = Double(textField.text ?? "") ?? 0.0
        presenter?.didChangeAmount(with: amount)
    }
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        let amount = Double(textField.text ?? "") ?? 0.0
        presenter?.didChangeAmount(with: amount)
    }
}
