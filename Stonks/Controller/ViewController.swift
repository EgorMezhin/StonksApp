//
//  ViewController.swift
//  Stonks
//
//  Created by Egor Lass on 30.01.2021.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - UI
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var companySymbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var companyLogoImage: UIImageView!
    
    //MARK: - TBD
    
    var stockManager = StockManager()
    
    var listOfCompanies: ListOfCompaniesModel?
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stockManager.delegate = self
        stockManager.requestListOfCompanies()
//        companyNameLabel.text = "-"
        companyPickerView.dataSource = self
        companyPickerView.delegate = self
        activityIndicator.hidesWhenStopped = true
        requestQuoteUpdate()
     //   stockManager.requestQuote(for: "aapl")
//        requestQuoteUpdate()
    }
    
    //MARK: - Refactor
    
    //Hard code companies
//    private lazy var companies = [
//        "Apple": "AAPL",
//        "Microsoft": "MSFT",
//        "Google": "GOOG",
//        "Amazon": "AMZN",
//        "Facebook": "FB",
//        "GameStop": "GME"
//    ]
    
   // private var companies = [String : String]()
    
    //URL requests
    
//    private func requestQuote(for symbol: String) {
//        let token = "pk_9126de53050040c1b737ead7a0720727"
//        guard let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/quote?token=\(token)") else {
//            return
//        }
//
//        guard let urlImage = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/logo?token=\(token)") else {
//            return
//        }
//
//        guard let urlLisOfCompanies = URL(string: "https://cloud.iexapis.com/stable/stock/market/list/mostactive/?token=\(token)") else {
//            return
//        }
//
//
//        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let data = data,
//               (response as? HTTPURLResponse)?.statusCode == 200,
//               error == nil {
//                self.parseQuote(from: data)
//            } else {
//                print("Network error!")
//            }
//        }
//
//        dataTask.resume()
//
//        let dataTaskForImageURL = URLSession.shared.dataTask(with: urlImage) { (data, response, error) in
//            if let data = data,
//               (response as? HTTPURLResponse)?.statusCode == 200,
//               error == nil {
//                self.parseQuoteForImage(from: data)
//            } else {
//                print("Network error!")
//            }
//        }
//
//        dataTaskForImageURL.resume()
//
//
//
//        let dataTaskForListOfCompanies = URLSession.shared.dataTask(with: urlLisOfCompanies) { (data, response, error) in
//            if let data = data,
//               (response as? HTTPURLResponse)?.statusCode == 200,
//               error == nil {
//                self.parseQuoteForImage(from: data)
//            } else {
//                print("Network error!")
//            }
//        }
//
//        dataTaskForListOfCompanies.resume()
//    }

//
//    private func parseQuote(from data: Data) {
//        do {
//            let jsonObject = try JSONSerialization.jsonObject(with: data)
//
//            guard
//                let json = jsonObject as? [String: Any],
//                let companyName = json["companyName"] as? String,
//                let companySymbol = json["symbol"] as? String,
//                let price = json["latestPrice"] as? Double,
//                let priceChange = json["change"] as? Double
//                else { return print("Invalid JSON")}
//
//            DispatchQueue.main.async { [weak self] in
//                self?.displayStockInfo(companyName: companyName,
//                                       companySymbol: companySymbol,
//                                       price: price,
//                                       priceChange: priceChange)
//            }
//        } catch {
//            print("JSON parsing error:" + error.localizedDescription)
//        }
//    }
//
//    private func parseQuoteForImage(from data: Data) {
//        do {
//            let jsonObject = try JSONSerialization.jsonObject(with: data)
//
//            guard
//                let json = jsonObject as? [String: Any],
//                let companyLogoURL = json["url"] as? String
//                else { return print("Invalid JSON image!")}
//
//            DispatchQueue.main.async { [weak self] in
//                self?.displayCompanyLogo(companyLogoURL: companyLogoURL)
//            }
//        } catch {
//            print("JSON parsing error:" + error.localizedDescription)
//        }
//    }
//
//
//    private func parseQuoteListOfCompanies(from data: Data) {
//        do {
//            let jsonObject = try JSONSerialization.jsonObject(with: data)
//
//            guard
//                let json = jsonObject as? [String: Any],
//                let companyName = json["companyName"] as? String,
//                let companySymbol = json["symbol"] as? String
//                else { return print("Invalid JSON")}
//
//            DispatchQueue.main.async { [weak self] in
//                self?.displayListOfCompanies(companyName: companyName,
//                                       companySymbol: companySymbol)
//            }
//        } catch {
//            print("JSON parsing error:" + error.localizedDescription)
//        }
//    }
//
    
    
    
//    private func displayCompanyLogo(companyLogoURL: String) {
//        print("image url - \(companyLogoURL)")
//        guard let url = URL(string: companyLogoURL) else {
//            return print("Can't download image")
//        }
//        let session = URLSession.shared
//        session.dataTask(with: url) { (data, response, error) in
//            if let data = data, let image = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    self.companyLogoImage.image = image
//                    self.companyLogoImage.contentMode = .scaleAspectFit
//                }
//            }
//        }.resume()
//    }
//
    
    
//    private func displayStockInfo(companyName: String,
//                                  companySymbol: String,
//                                  price: Double,
//                                  priceChange: Double) {
//        activityIndicator.stopAnimating()
//        companyNameLabel.text = companyName
//        companySymbolLabel.text = companySymbol
//        priceLabel.text = String(price)
//        priceChangeLabel.text = String(priceChange)
//       
//        if priceChange > 0 {
//            priceChangeLabel.textColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
//        } else if priceChange < 0 {
//            priceChangeLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
//        }
//    }
    
//    private func displayListOfCompanies(companyName: String,
//                                  companySymbol: String) {
//        print(companyName)
//        print(companySymbol)
//
//    }
    
    
    private func requestQuoteUpdate(with index: Int? = nil) {
        activityIndicator.startAnimating()
        companyNameLabel.text = "-"
        companySymbolLabel.text = "-"
        priceLabel.text = "-"
        priceChangeLabel.text = "-"
        priceChangeLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        companyLogoImage.image = nil

       // let selectedRow = companyPickerView.selectedRow(inComponent: 0)
       // let selectedSymbol = Array(companies.values)[selectedRow]
       //stockManager.requestQuote(for: selectedSymbol)
       //stockManager.requestListOfCompanies()
       // requestQuote(for: selectedSymbol)
       // didUpdateStocks(stocks: stoc)
        guard let companies = listOfCompanies?.array,
              let index = index,
              index < companies.count
        else {
            return
    }
        stockManager.requestQuote(for: companies[index].symbol)
        stockManager.requestImage(for: companies[index].symbol)
//    private func updateStockInfo(
//
//
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
     
       // print("image url - \(companyLogoURL)")
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
//            self.stockManager.requestQuote(for: companies.array[0].symbol)
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
