//
//  ViewController.swift
//  Stonks
//
//  Created by Egor Lass on 30.01.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var stockManager = StockManager()
    var listOfCompanies: ListOfCompaniesModel?
    
    //MARK: - UI
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var companySymbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var companyLogoImage: UIImageView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stockManager.delegate = self
        stockManager.requestListOfCompanies()
        
        companyPickerView.dataSource = self
        companyPickerView.delegate = self
        activityIndicator.hidesWhenStopped = true
        requestQuoteUpdate()
    }
    
    //MARK: - ???
  
    private func requestQuoteUpdate(with index: Int? = nil) {
        activityIndicator.startAnimating()
        companyNameLabel.text = "-"
        companySymbolLabel.text = "-"
        priceLabel.text = "-"
        priceChangeLabel.text = "-"
        priceChangeLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        companyLogoImage.image = nil
        
        guard let companies = listOfCompanies?.array,
              let index = index,
              index < companies.count
        else { return }
        
        stockManager.requestQuote(for: companies[index].symbol)
        stockManager.requestImage(for: companies[index].symbol)
    }
}

//MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listOfCompanies?.array.count ?? 0 //companies.keys.count
    }
}

//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listOfCompanies?.array[row].companyName //Array(companies.keys)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        requestQuoteUpdate(with: row)
    }
}

//MARK: - StocksManagerDelegate

extension ViewController: StocksManagerDelegate {
    func didUpdateImage(image: ImageModel) {
        guard let url = URL(string: image.url) else {
            return print("Can't download image")
        }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.companyLogoImage.image = image
                    self.companyLogoImage.contentMode = .scaleAspectFit
                }
            }
        }.resume()
    }
    
    func didUpdateCompanies(companies: ListOfCompaniesModel) {
        DispatchQueue.main.async {
            self.listOfCompanies = companies
            self.companyPickerView.reloadAllComponents()
            self.requestQuoteUpdate(with: 0)
        }
    }
    
    func didUpdateStocks(stocks: StocksModel) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.companyNameLabel.text = stocks.companyName
            self.companySymbolLabel.text = stocks.companySymbol
            self.priceLabel.text = String(stocks.price)
            self.priceChangeLabel.text = String(stocks.priceChange)
            
            if stocks.priceChange > 0 {
                self.priceChangeLabel.textColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            } else if stocks.priceChange < 0 {
                self.priceChangeLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
        }
    }
}
