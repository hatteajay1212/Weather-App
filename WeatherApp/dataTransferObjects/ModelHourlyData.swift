//
//  ModelHourlyDataResponse.swift
//  WeatherApp
//
//  Created by Ajay Hatte on 26/06/24.
//

import Foundation

struct ModelHourlyData : Codable{
    let dt : Int?
    let temprature : ModelTemperatureData?
    let visibility : Int?
    let dt_txt : String?

    enum CodingKeys: String, CodingKey {
        case dt = "dt"
        case temprature = "main"
        case visibility = "visibility"
        case dt_txt = "dt_txt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dt = try values.decodeIfPresent(Int.self, forKey: .dt)
        temprature = try values.decodeIfPresent(ModelTemperatureData.self, forKey: .temprature)
        visibility = try values.decodeIfPresent(Int.self, forKey: .visibility)
        dt_txt = try values.decodeIfPresent(String.self, forKey: .dt_txt)
    }
}
