//
//  ViewController.swift
//  Stonks
//
//  Created by Egor Lass on 30.01.2021.
//

import UIKit
import Charts

class ViewController: UIViewController {
    
    var stocksChart = LineChartView()
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
    @IBOutlet weak var lineChartView: LineChartView!
    
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
    
    //MARK: - RequestQuoteUpdate
  
    private func requestQuoteUpdate(with index: Int? = nil) {
        activityIndicator.startAnimating()
        companyNameLabel.text = "-"
        companySymbolLabel.text = "-"
        priceLabel.text = "-"
        priceChangeLabel.text = "-"
        priceChangeLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        companyLogoImage.image = nil
        lineChartView.isHidden = true
        
        guard let companies = listOfCompanies?.array,
              let index = index,
              index < companies.count
        else { return }
        
        stockManager.requestQuote(for: companies[index].symbol)
        stockManager.requestImage(for: companies[index].symbol)
        stockManager.requestChart(for: companies[index].symbol)
    }
}

//MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listOfCompanies?.array.count ?? 0
    }
}

//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listOfCompanies?.array[row].companyName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        requestQuoteUpdate(with: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label:UILabel
        if let view = view as? UILabel{
            label = view
        } else {
            label = UILabel()
        }
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = listOfCompanies?.array[row].companyName
        return label
    }
}

//MARK: - StocksManagerDelegate

extension ViewController: StocksManagerDelegate {
    
    func networkError(error: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Refresh", style: .default, handler: {_ in
//????
                self.viewDidLoad()
            }))
            self.present(alert, animated: true)
        }
    }
    
    func didUpdateChart(chart: ChartModel) {
        DispatchQueue.main.async {
            let values = (0..<chart.array.count).map { (i) -> ChartDataEntry in
                let val = Double(chart.array[i].close)
                return ChartDataEntry(x: Double(i), y: val)
            }
            let set = LineChartDataSet(entries: values, label: "Last 30 days history")
            let legend = self.lineChartView.legend
            legend.font = UIFont.systemFont(ofSize: 14)
            set.colors = [#colorLiteral(red: 1, green: 0.5427501798, blue: 0.2194631696, alpha: 1)]
            set.drawCirclesEnabled = false
            set.drawValuesEnabled = false
            set.lineWidth = 3
            set.drawFilledEnabled = true
            let data = LineChartData(dataSet: set)
            self.lineChartView.isUserInteractionEnabled = true
            self.lineChartView.data = data
            self.lineChartView.isHidden = false
            self.lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: [])
        }
    }
    
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
                self.priceChangeLabel.textColor = #colorLiteral(red: 0, green: 0.7856185725, blue: 0, alpha: 1)
            } else if stocks.priceChange < 0 {
                self.priceChangeLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
        }
    }
}
