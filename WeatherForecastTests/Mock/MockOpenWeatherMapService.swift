//
//  MockOpenWeatherMapService.swift
//  WeatherForecastTests
//
//  Created by Minh Nguyen on 3/1/21.
//

import RxSwift
import RxCocoa

@testable import WeatherForecast

class MockOpenWeatherMapService: OpenWeatherMapService {
    var timesThatGetWeatherForecastCalled = 0
    var paramOfGetWeatherForecast = ""
    var getWeatherForecastReturnsError = false
    
    func getWeatherForecast(withQuery query: String) -> Observable<Result<DailyForecastList, Error>> {
        timesThatGetWeatherForecastCalled += 1
        paramOfGetWeatherForecast = query
        
        if getWeatherForecastReturnsError {
            return .just(.failure(NSError()))
        }
        
        let items = [
            DailyForecastItem(date: 1614488400,
                              pressure: 1010,
                              humidity: 38,
                              weathers: [Weather(description: "sky is clear")],
                              temperature: Temperature(min: 23.43, max: 35.11)),
            DailyForecastItem(date: 1614574800,
                              pressure: 1011,
                              humidity: 36,
                              weathers: [Weather(description: "scattered clouds")],
                              temperature: Temperature(min: 24.34, max: 36.03))
        ]
        let list = DailyForecastList(list: items)

        return .just(.success(list))
    }
}
