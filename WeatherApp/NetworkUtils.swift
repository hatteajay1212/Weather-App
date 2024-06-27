//
//  NetworkUtils.swift
//  WeatherApp
//
//  Created by Ajay Hatte on 25/06/24.
//

import Foundation
import SystemConfiguration

struct NetworkUtils{
    static let URL_CURRENT_WEATHER_DATA = "https://api.openweathermap.org/data/2.5/weather"
    static let URL_HOURLY_WEATHER_DATA = "https://pro.openweathermap.org/data/2.5/forecast/hourly"
    static let URL_DAILY_WEATHER_DATA = "https://api.weatherapi.com/v1/forecast.json"
    
    static func isInternetAvailable() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}

struct APIKeys{
    static let KEY_LATITUDE = "lat"
    static let KEY_LONGITUDE = "lon"
    static let KEY_APP_ID = "appid"
    static let KEY_APP_KEY = "key"
    static let KEY_QUERY = "q"
    static let KEY_NO_OF_DAYS = "days"
    static let KEY_UNITS = "units"
}

struct APIErrorCodes{
    static let ERROR_CODE_API_KEY_INVALID = 401
    static let ERROR_CODE_AUTHENTICATION = 403
    static let ERROR_CODE_INVALID_QUERY_PARAM = 400
}
