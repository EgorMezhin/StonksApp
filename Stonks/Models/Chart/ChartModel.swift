//
//  ChartModel.swift
//  Stonks
//
//  Created by Egor Lass on 31.01.2021.
//

import Foundation

struct ChartModel: Decodable {
    let array: [StockValue]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode([StockValue].self)
        array = values
    }
}

struct StockValue: Decodable {
    let close: Double
    let symbol: String
    let label: String
}
