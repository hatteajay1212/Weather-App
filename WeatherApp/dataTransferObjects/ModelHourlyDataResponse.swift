//
//  ModelHourlyDataResponse.swift
//  WeatherApp
//
//  Created by Ajay Hatte on 26/06/24.
//

import Foundation

struct ModelHourlyDataResponse : Codable{
    let cnt : Int?
    let list : [ModelHourlyData]?

    enum CodingKeys: String, CodingKey {
        case cnt = "cnt"
        case list = "list"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cnt = try values.decodeIfPresent(Int.self, forKey: .cnt)
        list = try values.decodeIfPresent([ModelHourlyData].self, forKey: .list)
    }
}
