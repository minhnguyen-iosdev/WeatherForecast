//
//  DailyForecastList.swift
//  WeatherForecast
//
//  Created by Minh Nguyen on 2/28/21.
//

import Foundation

struct DailyForecastList: Codable {
    let cod: String
    let message: Double
    let cnt: Int
    let list: [DailyForecastItem]
}
