//
//  StocksData.swift
//  Stonks
//
//  Created by Egor Lass on 30.01.2021.
//

import Foundation

struct StocksData: Decodable {
    let symbol: String
    let companyName: String
    let latestPrice: Double
    let change: Double
}
