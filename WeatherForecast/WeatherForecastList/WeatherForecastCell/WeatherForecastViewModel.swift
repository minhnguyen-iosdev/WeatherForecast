//
//  WeatherForecastViewModel.swift
//  WeatherForecast
//
//  Created by Minh Nguyen on 2/27/21.
//

import Foundation

struct WeatherForecastViewModel: Hashable {
    let date: String
    let averageTemperature: String
    let pressure: String
    let humidity: String
    let description: String
    
    init(date: String,
         averageTemperature: String,
         pressure: String,
         humidity: String,
         description: String) {
        self.date = date
        self.averageTemperature = averageTemperature
        self.pressure = pressure
        self.humidity = humidity
        self.description = description
    }
}
