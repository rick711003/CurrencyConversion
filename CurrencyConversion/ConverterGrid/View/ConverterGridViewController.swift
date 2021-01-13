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
    private var pickerView: UIPickerView?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "ExchangeRateCell", bundle: nil),
                                forCellWithReuseIdentifier: "ExchangeRateCell")
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
    
    func showCurrencyPickerView() {
        let alertController = UIAlertController(title: "Select Currency",
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let currencyPickerView = UIPickerView()
        alertController.view.addSubview(currencyPickerView)
        currencyPickerView.translatesAutoresizingMaskIntoConstraints = false
        currencyPickerView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 45).isActive = true
        currencyPickerView.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -10).isActive = true
        currencyPickerView.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 10).isActive = true
        currencyPickerView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        currencyPickerView.dataSource = self
        currencyPickerView.delegate = self
        
        alertController.view.translatesAutoresizingMaskIntoConstraints = false
        alertController.view.heightAnchor.constraint(equalToConstant: 370).isActive = true

        currencyPickerView.backgroundColor = .clear
        pickerView = currencyPickerView
        setCurrencyPickerDefaultValue(with: currencyPickerView)
        
        let cancelAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func setCurrencyPickerDefaultValue(with picker: UIPickerView) {
        var defaultIndex = 0
        if let currentSelectedCurrency = presenter?.currentSelectedCurrency {
            defaultIndex = presenter?.currencies.firstIndex { $0.shotName == currentSelectedCurrency.shotName } ?? 0
        } else {
            defaultIndex = presenter?.currencies.firstIndex { $0.shotName == "USD"} ?? 0
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
        currencyButton.setTitle(presenter?.currentSelectedCurrency?.shotName ?? "UNKNOW",
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExchangeRateCell", for: indexPath)
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
        let cellWidth = (self.view.bounds.width - 20 - 4) / 3
        return CGSize(width: cellWidth, height: 100.0)
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
