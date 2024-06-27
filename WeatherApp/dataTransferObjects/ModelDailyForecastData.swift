//
//  ModelDailyTempData.swift
//  WeatherApp
//
//  Created by Ajay Hatte on 26/06/24.
//

import Foundation

struct ModelDailyForecastData : Codable{
    let date : String?
    let date_epoch : Int?
    let day : ModelDailyWeatherData?

    enum CodingKeys: String, CodingKey{
        case date = "date"
        case date_epoch = "date_epoch"
        case day = "day"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        date_epoch = try values.decodeIfPresent(Int.self, forKey: .date_epoch)
        day = try values.decodeIfPresent(ModelDailyWeatherData.self, forKey: .day)
    }
}
