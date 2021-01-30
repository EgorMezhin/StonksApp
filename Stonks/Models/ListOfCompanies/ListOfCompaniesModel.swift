//
//  ListOfCompaniesModel.swift
//  Stonks
//
//  Created by Egor Lass on 30.01.2021.
//

import Foundation

struct ListOfCompaniesModel: Codable {
    let array: [Company]
    
    init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let companies = try container.decode([Company].self)
            array = companies
        }
}

struct Company: Codable {
    let companyName: String
    let symbol: String
}
