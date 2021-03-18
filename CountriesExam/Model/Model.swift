//
//  Model.swift
//  CountriesExam
//
//  Created by Blue Solution Networks on 3/18/21.
//

import Foundation

struct Countries: Decodable {
    var name: String!
    var cioc: String!
    var capital: String!
    var alpha2Code: String!
    var alpha3Code: String!
    var flag: String!
    var population: Int!
    
    private enum CodingKeys: String, CodingKey {
        case name, cioc, capital, flag, population
        case alpha2Code = "alpha2Code"
        case alpha3Code = "alpha3Code"
    }
}
