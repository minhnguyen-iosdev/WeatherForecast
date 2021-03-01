//
//  OpenWeatherMapServiceTests.swift
//  WeatherForecastTests
//
//  Created by Minh Nguyen on 3/2/21.
//

import XCTest

@testable import WeatherForecast

class OpenWeatherMapServiceTests: XCTestCase {
    private let openWeatherMapService = DefaultOpenWeatherMapService()

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_makeWeatherDailyForecastURL() throws {
        let output = openWeatherMapService.makeWeatherDailyForecastURL(withQuery: "saigon")
        
        XCTAssertEqual(output.absoluteString, "https://api.openweathermap.org/data/2.5/forecast/daily?q=saigon&cnt=7&appid=60c6fbeb4b93ac653c492ba806fc346d&units=metric")
    }
}
