//
//  DailyForecastItem.swift
//  WeatherForecast
//
//  Created by Minh Nguyen on 2/28/21.
//

import Foundation

struct DailyForecastItem: Codable {
    let date: Int
    let pressure: Int
    let humidity: Int
    let weathers: [Weather]
    let temperature: Temperature
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case pressure
        case humidity
        case weathers = "weather"
        case temperature = "temp"
    }
}
