//
//  ViewController.swift
//  Stonks
//
//  Created by Egor Lass on 30.01.2021.
//

import UIKit
import Charts

class ViewController: UIViewController {
    
    static let textPlaceholder = "-"
    
    private let stocksChart = LineChartView()
    private var stockManager = StockManager()
    private var listOfCompanies: ListOfCompaniesModel?

    //MARK: - UI properties
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyPickerView: UIPickerView! {
        didSet {
            companyPickerView.dataSource = self
            companyPickerView.delegate = self
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
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
    }
}

//MARK: - Private methods
extension ViewController {
   
    private func cleanDisplay() {
        activityIndicator.startAnimating()
        companyNameLabel.text = ViewController.textPlaceholder
        companySymbolLabel.text = ViewController.textPlaceholder
        priceLabel.text = ViewController.textPlaceholder
        priceChangeLabel.text = ViewController.textPlaceholder
        priceChangeLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        companyLogoImage.image = nil
        lineChartView.isHidden = true
    }
    
    private func fetchDataForCompany(_ index: Int) {
        guard let companies = listOfCompanies?.array,
              index < companies.count
        else { return }
        
        stockManager.requestQuote(for: companies[index].symbol)
        stockManager.requestImage(for: companies[index].symbol)
        stockManager.requestChart(for: companies[index].symbol)
    }
    
    private func pickerViewLabelAdjustsFontSizeToFitWidth(reusing view: UIView?, forIndex index: Int) -> UIView {
        var label: UILabel
        if let view = view as? UILabel{
            label = view
        } else {
            label = UILabel()
        }
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = listOfCompanies?.array[index].companyName
        return label
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
        cleanDisplay()
        fetchDataForCompany(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        pickerViewLabelAdjustsFontSizeToFitWidth(reusing: view, forIndex: row)
    }
}

//MARK: - StocksManagerDelegate
extension ViewController: StocksManagerDelegate {
    
    func networkError(error: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Refresh", style: .default, handler: {_ in
                self?.cleanDisplay()
                self?.stockManager.requestListOfCompanies()
            }))
            self?.present(alert, animated: true)
        }
    }
    
    func didUpdateChart(chart: ChartModel) {
        DispatchQueue.main.async { [weak self] in
            let values = (0..<chart.array.count).map { (i) -> ChartDataEntry in
                let val = Double(chart.array[i].close)
                return ChartDataEntry(x: Double(i), y: val)
            }
            let set = LineChartDataSet(entries: values, label: "Last 30 days history")
            let legend = self?.lineChartView.legend
            legend?.font = UIFont.systemFont(ofSize: 14)
            set.colors = [#colorLiteral(red: 1, green: 0.5427501798, blue: 0.2194631696, alpha: 1)]
            set.drawCirclesEnabled = false
            set.drawValuesEnabled = false
            set.lineWidth = 3
            set.drawFilledEnabled = true
            let data = LineChartData(dataSet: set)
            self?.lineChartView.isUserInteractionEnabled = true
            self?.lineChartView.data = data
            self?.lineChartView.isHidden = false
            self?.lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: [])
        }
    }
    
    func didUpdateImage(image: ImageModel) {
        guard let url = URL(string: image.url) else {
            return print("Can't download image")
        }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async { [weak self] in
                    self?.companyLogoImage.image = image
                    self?.companyLogoImage.contentMode = .scaleAspectFit
                }
            }
        }.resume()
    }
    
    func didUpdateCompanies(companies: ListOfCompaniesModel) {
        DispatchQueue.main.async {
            self.listOfCompanies = companies
            self.companyPickerView.reloadAllComponents()
            self.cleanDisplay()
            let index = self.companyPickerView.selectedRow(inComponent: 0)
            self.fetchDataForCompany(index)
        }
    }
    
    func didUpdateStocks(stocks: StocksModel) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.companyNameLabel.text = stocks.companyName
            self?.companySymbolLabel.text = stocks.companySymbol
            self?.priceLabel.text = String(stocks.price)
            self?.priceChangeLabel.text = String(stocks.priceChange)
            self?.priceChangeLabel.textColor = stocks.priceChange > 0 ? #colorLiteral(red: 0, green: 0.7856185725, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
    }
}
