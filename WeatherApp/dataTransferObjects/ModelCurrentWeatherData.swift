//
//  ModelCurrentWeatherData.swift
//  WeatherApp
//
//  Created by Ajay Hatte on 26/06/24.
//

import Foundation

struct ModelCurrentWeatherData : Codable {
    let weather : [ModelWeather]?
    let temperature : ModelTemperatureData?
    let visibility : Int?

    enum CodingKeys: String, CodingKey {
        case weather = "weather"
        case temperature = "main"
        case visibility = "visibility"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        weather = try values.decodeIfPresent([ModelWeather].self, forKey: .weather)
        temperature = try values.decodeIfPresent(ModelTemperatureData.self, forKey: .temperature)
        visibility = try values.decodeIfPresent(Int.self, forKey: .visibility)
    }
}
