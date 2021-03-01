//
//  JSONDecodeTests.swift
//  WeatherForecastTests
//
//  Created by Minh Nguyen on 3/2/21.
//

import XCTest

@testable import WeatherForecast

class JSONDecodeTests: XCTestCase {
    func test_JSONDecodeDailyForecastList() throws {
        let jsonData = dailyForecastListJSONString.data(using: .utf8)
        let decoder = JSONDecoder()
        let dailyForcast = try! decoder.decode(DailyForecastList.self, from: jsonData!)
        
        XCTAssertEqual(dailyForcast.list.count, 7)
        XCTAssertEqual(dailyForcast.list[0].date, 1614661200)
        XCTAssertEqual(dailyForcast.list[0].humidity, 40)
        XCTAssertEqual(dailyForcast.list[0].pressure, 1011)
        XCTAssertEqual(dailyForcast.list[0].temperature.max, 36.24)
        XCTAssertEqual(dailyForcast.list[0].weathers[0].description, "light rain")
    }

    var dailyForecastListJSONString: String {
        return """
        {"city":{"id":1580578,"name":"Ho Chi Minh City","coord":{"lon":106.6667,"lat":10.8333},"country":"VN","population":0,"timezone":25200},"cod":"200","message":6.5922458,"cnt":7,"list":[{"dt":1614661200,"sunrise":1614640071,"sunset":1614683012,"temp":{"day":35.11,"min":23.65,"max":36.24,"night":25.59,"eve":29.43,"morn":23.65},"feels_like":{"day":37,"night":27.31,"eve":28.43,"morn":26.93},"pressure":1011,"humidity":40,"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10d"}],"speed":2.21,"deg":47,"clouds":13,"pop":0.52,"rain":0.8},{"dt":1614747600,"sunrise":1614726441,"sunset":1614769417,"temp":{"day":35.68,"min":23.48,"max":37.36,"night":27.8,"eve":29.16,"morn":23.48},"feels_like":{"day":37.33,"night":27.8,"eve":28.34,"morn":26.53},"pressure":1011,"humidity":35,"weather":[{"id":800,"main":"Clear","description":"sky is clear","icon":"01d"}],"speed":1.53,"deg":54,"clouds":8,"pop":0.45},{"dt":1614834000,"sunrise":1614812810,"sunset":1614855821,"temp":{"day":37.69,"min":25.31,"max":37.69,"night":26.48,"eve":28.15,"morn":25.53},"feels_like":{"day":38.47,"night":26.32,"eve":28.13,"morn":27.05},"pressure":1010,"humidity":27,"weather":[{"id":800,"main":"Clear","description":"sky is clear","icon":"01d"}],"speed":1.43,"deg":24,"clouds":2,"pop":0.03},{"dt":1614920400,"sunrise":1614899178,"sunset":1614942225,"temp":{"day":38.06,"min":24.07,"max":38.06,"night":24.61,"eve":26.38,"morn":24.6},"feels_like":{"day":37.31,"night":24.64,"eve":25.69,"morn":25.86},"pressure":1010,"humidity":22,"weather":[{"id":800,"main":"Clear","description":"sky is clear","icon":"01d"}],"speed":2.22,"deg":102,"clouds":1,"pop":0},{"dt":1615006800,"sunrise":1614985546,"sunset":1615028629,"temp":{"day":36.96,"min":22.89,"max":36.96,"night":25.27,"eve":27.02,"morn":23.53},"feels_like":{"day":36.47,"night":26.03,"eve":26.11,"morn":25.61},"pressure":1010,"humidity":26,"weather":[{"id":800,"main":"Clear","description":"sky is clear","icon":"01d"}],"speed":2.63,"deg":36,"clouds":0,"pop":0},{"dt":1615093200,"sunrise":1615071914,"sunset":1615115032,"temp":{"day":37.8,"min":23.99,"max":37.8,"night":26.83,"eve":28.24,"morn":24.3},"feels_like":{"day":37.59,"night":26.77,"eve":27.71,"morn":26.42},"pressure":1010,"humidity":23,"weather":[{"id":800,"main":"Clear","description":"sky is clear","icon":"01d"}],"speed":1.67,"deg":29,"clouds":0,"pop":0},{"dt":1615179600,"sunrise":1615158281,"sunset":1615201435,"temp":{"day":37.31,"min":24.8,"max":37.31,"night":27.22,"eve":28.33,"morn":25.27},"feels_like":{"day":38.48,"night":25.81,"eve":27.3,"morn":26.82},"pressure":1010,"humidity":30,"weather":[{"id":800,"main":"Clear","description":"sky is clear","icon":"01d"}],"speed":1.6,"deg":42,"clouds":2,"pop":0}]}
        """
    }
}
