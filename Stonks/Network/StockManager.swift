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
}

struct StockManager {
    
    var delegate: StocksManagerDelegate?
    let token = "pk_9126de53050040c1b737ead7a0720727"
    let urlGeneral = "https://cloud.iexapis.com/stable/stock/"
    
    func requestQuote(for symbol: String) {
        guard let url = URL(string: "\(urlGeneral)\(symbol)/quote?token=\(token)")
        else {
            return print("Can't assign StocksURL to a constant")
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data,
               (response as? HTTPURLResponse)?.statusCode == 200,
               error == nil {
                if let stocks = self.parseQuote(from: data) {
                    self.delegate?.didUpdateStocks(stocks: stocks)
                }
            } else {
                print("Network error. Problem with url")
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
    
    
    func requestImage(for symbol: String) {
        guard let urlImage = URL(string: "\(urlGeneral)\(symbol)/logo?token=\(token)")
        else {
            return print("Can't assign ImageURL to a constant")
        }
        
        let dataTask = URLSession.shared.dataTask(with: urlImage) { (data, response, error) in
            if let data = data,
               (response as? HTTPURLResponse)?.statusCode == 200,
               error == nil {
           //???
                if let imageModel = self.parseQuoteForImage(from: data) {
                    self.delegate?.didUpdateImage(image: imageModel)
                }
            } else {
                print("Network error. Problem with url")
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
    
    
    
    
    ///
    
    func requestListOfCompanies(){
        guard let urlListOfCompanies = URL(string: "\(urlGeneral)market/list/mostactive/?token=\(token)")
        else {
            return print("Can't assign CompaniesListURL to a constant")
        }
        let dataTask = URLSession.shared.dataTask(with: urlListOfCompanies) { (data, response, error) in
            if let data = data,
               (response as? HTTPURLResponse)?.statusCode == 200,
               error == nil {
                if let companies = self.parseQuoteListOfCompanies(from: data) {
                    self.delegate?.didUpdateCompanies(companies: companies)
                }
            } else {
                print("Network error. Problem with url")
            }
        }
        dataTask.resume()
        
    }
    
    private func parseQuoteListOfCompanies(from data: Data) -> ListOfCompaniesModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ListOfCompaniesModel.self, from: data)
            let array = decodedData.array

//            if (try decoder.decode(ListOfCompaniesModel.self, from: data)) != nil {
//
//            }
//
//            else { return nil /*print("Invalid JSON")*/}
            
            //                DispatchQueue.main.async { [weak self] in
            //                    self?.displayListOfCompanies(companyName: companyName,
            //                                           companySymbol: companySymbol)
            //                return nil
            //                }
            return decodedData
        } catch {
            print("JSON parsing error:" + error.localizedDescription)
            return nil
        }
    }
    
    
    
//        let dataTaskForImageURL = URLSession.shared.dataTask(with: urlImage) { (data, response, error) in
//            if let data = data,
//               (response as? HTTPURLResponse)?.statusCode == 200,
//               error == nil {
//                self.parseQuoteForImage(from: data)
//            } else {
//                print("Network error. Problem with urlImage")
//            }
//        }
//        dataTaskForImageURL.resume()
//
//        let dataTaskForListOfCompanies = URLSession.shared.dataTask(with: urlLisOfCompanies) { (data, response, error) in
//            if let data = data,
//               (response as? HTTPURLResponse)?.statusCode == 200,
//               error == nil {
//                self.parseQuoteForImage(from: data)
//            } else {
//                print("Network error. Problem with urlListOfCompanies")
//            }
//        }
//        dataTaskForListOfCompanies.resume()

    
    
    
    

    
    
//    private func parseQuoteForImage(from data: Data) {
//        do {
//            let jsonObject = try JSONSerialization.jsonObject(with: data)
//
//            guard
//                let json = jsonObject as? [String: Any],
//                let companyLogoURL = json["url"] as? String
//                else { return print("Invalid JSON image!")}
//
////            DispatchQueue.main.async {
////                self.displayCompanyLogo(companyLogoURL: companyLogoURL)
////            }
//        } catch {
//            print("JSON parsing error:" + error.localizedDescription)
//        }
//    }
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
    
    
    
    
}