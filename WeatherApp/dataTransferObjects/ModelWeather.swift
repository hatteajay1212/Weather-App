//
//  ModelWeather.swift
//  WeatherApp
//
//  Created by Ajay Hatte on 26/06/24.
//

import Foundation

struct ModelWeather : Codable {
    let id : Int?
    let main : String?
    let description : String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case main = "main"
        case description = "description"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        main = try values.decodeIfPresent(String.self, forKey: .main)
        description = try values.decodeIfPresent(String.self, forKey: .description)
    }
}
