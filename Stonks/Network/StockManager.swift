//
//  StockManager.swift
//  Stonks
//
//  Created by Egor Lass on 30.01.2021.
//

import Foundation

protocol StocksManagerDelegate {
    func didUpdateStocks(stocks: StocksModel)
    func didUpdateCompanies(companies: ListOfCompaniesModel)
    func didUpdateImage(image: ImageModel)
    func didUpdateChart(chart: ChartModel)
    func networkError(error: String, message: String)
}

struct StockManager {
    var delegate: StocksManagerDelegate?
    let token = "pk_fd420fdd69894f3aa18b7016cb21dcdc"
    let urlGeneral = "https://cloud.iexapis.com/stable/stock/"
    
    //MARK: - Quote
    func requestQuote(for symbol: String) {
        guard let url = URL(string: "\(urlGeneral)\(symbol)/quote?token=\(token)")
        else {
            fatalError("Can't assign StocksURL to a constant")
        }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data,
               (response as? HTTPURLResponse)?.statusCode == 200,
               error == nil {
                if let stocks = self.parseQuote(from: data) {
                    self.delegate?.didUpdateStocks(stocks: stocks)
                }
            } else if (response as? HTTPURLResponse)?.statusCode ?? 0 >= 400 && (response as? HTTPURLResponse)?.statusCode ?? 0 <= 500 {
                self.delegate?.networkError(error: "Something broke in the network layer",
                                            message: "Please use the app later")
            } else {
                self.delegate?.networkError(error: "Loading information from server error",
                                            message: "Please check your internet connection")
            }
        }
        dataTask.resume()
    }
    
    func parseQuote(from data: Data) -> StocksModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(StocksData.self, from: data)
            let name = decodedData.companyName
            let symbol = decodedData.symbol
            let price = decodedData.latestPrice
            let priceChange = decodedData.change
            let stocksModel = StocksModel(companyName: name, companySymbol: symbol, price: price, priceChange: priceChange)
            return stocksModel
        } catch {
            print("JSON parsing error:" + error.localizedDescription)
            return nil
        }
    }
    
    //MARK: - Image
    func requestImage(for symbol: String) {
        guard let urlImage = URL(string: "\(urlGeneral)\(symbol)/logo?token=\(token)")
        else {
            fatalError("Can't assign ImageURL to a constant")
        }
        let dataTask = URLSession.shared.dataTask(with: urlImage) { (data, response, error) in
            if let data = data,
               (response as? HTTPURLResponse)?.statusCode == 200,
               error == nil {
                if let imageModel = self.parseQuoteForImage(from: data) {
                    self.delegate?.didUpdateImage(image: imageModel)
                }
            } else if (response as? HTTPURLResponse)?.statusCode ?? 0 >= 400 && (response as? HTTPURLResponse)?.statusCode ?? 0 <= 500 {
                self.delegate?.networkError(error: "Something broke in the network layer",
                                            message: "Please use the app later")
            } else {
                self.delegate?.networkError(error: "Image loading error",
                                            message: "Please check your internet connection")
            }
        }
        dataTask.resume()
    }
    
    private func parseQuoteForImage(from data: Data) -> ImageModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ImageModel.self, from: data)
            return decodedData
        } catch {
            print("JSON parsing error:" + error.localizedDescription)
            return nil
        }
    }
    
    //MARK: - ListOfCompanies
    func requestListOfCompanies() {
        guard let urlListOfCompanies = URL(string: "\(urlGeneral)market/list/mostactive/?token=\(token)")
        else {
            fatalError("Can't assign CompaniesListURL to a constant")
        }
        let dataTask = URLSession.shared.dataTask(with: urlListOfCompanies) { (data, response, error) in
            if let data = data,
               (response as? HTTPURLResponse)?.statusCode == 200,
               error == nil {
                if let companies = self.parseQuoteListOfCompanies(from: data) {
                    self.delegate?.didUpdateCompanies(companies: companies)
                }
            } else if (response as? HTTPURLResponse)?.statusCode ?? 0 >= 400 && (response as? HTTPURLResponse)?.statusCode ?? 0 <= 500 {
                self.delegate?.networkError(error: "Something broke in the network layer",
                                            message: "Please use the app later")
            } else {
                self.delegate?.networkError(error: "Loading information from server error",
                                            message: "Please check your internet connection")
            }
        }
        dataTask.resume()
    }
    
    private func parseQuoteListOfCompanies(from data: Data) -> ListOfCompaniesModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ListOfCompaniesModel.self, from: data)
            return decodedData
        } catch {
            print("JSON parsing error:" + error.localizedDescription)
            return nil
        }
    }
    
    //MARK: - Chart
    func requestChart(for symbol: String) {
        guard let urlChart = URL(string: "\(urlGeneral)\(symbol)/chart/1m?token=\(token)")
        else {
            fatalError("Can't assign ChartURL to a constant")
        }
        let dataTask = URLSession.shared.dataTask(with: urlChart) { (data, response, error) in
            if let data = data,
               (response as? HTTPURLResponse)?.statusCode == 200,
               error == nil {
                if let chart = self.parseChart(from: data) {
                    self.delegate?.didUpdateChart(chart: chart)
                }
            } else if (response as? HTTPURLResponse)?.statusCode ?? 0 >= 400 && (response as? HTTPURLResponse)?.statusCode ?? 0 <= 500 {
                self.delegate?.networkError(error: "Something broke in the network layer",
                                            message: "Please use the app later")
            } else {
                self.delegate?.networkError(error: "Chart loading error",
                                            message: "Please check your internet connection")
            }
        }
        dataTask.resume()
    }
    
    func parseChart(from data: Data) -> ChartModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ChartModel.self, from: data)
            
            return decodedData
        } catch {
            print("JSON parsing error:" + error.localizedDescription)
            return nil
        }
    }
}
