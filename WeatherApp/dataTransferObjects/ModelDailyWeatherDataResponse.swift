//
//  ModelDailyWeatherDataResponse.swift
//  WeatherApp
//
//  Created by Ajay Hatte on 26/06/24.
//

import Foundation

struct ModelDailyWeatherDataResponse : Codable{
    let forecast : ModelDailyForecast?

    enum CodingKeys: String, CodingKey {
        case forecast = "forecast"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        forecast = try values.decodeIfPresent(ModelDailyForecast.self, forKey: .forecast)
    }
}

struct ModelDailyForecast : Codable{
    let forecastday : [ModelDailyForecastData]?
    
    enum CodingKeys: String, CodingKey {
        case forecastday = "forecastday"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        forecastday = try values.decodeIfPresent([ModelDailyForecastData].self, forKey: .forecastday)
    }
}
