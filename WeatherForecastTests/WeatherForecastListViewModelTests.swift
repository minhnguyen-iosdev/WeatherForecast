//
//  WeatherForecastListViewModelTests.swift
//  WeatherForecastTests
//
//  Created by Minh Nguyen on 3/1/21.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest

@testable import WeatherForecast

class WeatherForecastListViewModelTests: XCTestCase {
    private var openWeatherMapService: MockOpenWeatherMapService!
    private var scheduler: TestScheduler!
    private var viewModel: DefaultWeatherForecastListViewModel!
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        openWeatherMapService = MockOpenWeatherMapService()
        scheduler = TestScheduler(initialClock: 0)
        viewModel = DefaultWeatherForecastListViewModel(openWeatherMapService: openWeatherMapService,
                                                        scheduler: scheduler)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        openWeatherMapService = nil
        scheduler = nil
        viewModel = nil
        disposeBag = nil
    }

    func test_initialValues() throws {
        // Given an initialized viewModel
        
        // Bind output
        let itemsResult = scheduler.createObserver([WeatherForecastViewModel].self)
        viewModel.output.items
            .bind(to: itemsResult)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Then items is triggered once
        XCTAssertEqual(itemsResult.events.count, 1)
        
        // And it is empty
        XCTAssertEqual(itemsResult.events.last!.value.element!.count, 0)
    }

    func test_searchText_success() throws {
        // Given an initialized viewModel
        
        // Bind output
        let itemsResult = scheduler.createObserver([WeatherForecastViewModel].self)
        viewModel.output.items
            .bind(to: itemsResult)
            .disposed(by: disposeBag)
        
        // When searching
        
        scheduler.createColdObservable([.next(10, "s")])
            .bind(to: viewModel.input.searchText)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(20, "sa")])
            .bind(to: viewModel.input.searchText)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(30, "sai")])
            .bind(to: viewModel.input.searchText)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Then items is triggered twice
        XCTAssertEqual(itemsResult.events.count, 2)
        
        // And number of items is correct
        XCTAssertEqual(itemsResult.events.last!.value.element!.count, 2)
        
        // openWeatherMapService's getWeatherForecast is called once and param is correct
        XCTAssertEqual(openWeatherMapService.timesThatGetWeatherForecastCalled, 1)
        XCTAssertEqual(openWeatherMapService.paramOfGetWeatherForecast, "sai")
    }
    
    func test_searchText_error() throws {
        // Given an initialized viewModel
        // and openWeatherMapService's getWeatherForecast returns error
        openWeatherMapService.getWeatherForecastReturnsError = true
        
        // Bind output
        let itemsResult = scheduler.createObserver([WeatherForecastViewModel].self)
        viewModel.output.items
            .bind(to: itemsResult)
            .disposed(by: disposeBag)
        
        // When searching
        
        scheduler.createColdObservable([.next(10, "s")])
            .bind(to: viewModel.input.searchText)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(20, "sa")])
            .bind(to: viewModel.input.searchText)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(30, "sai")])
            .bind(to: viewModel.input.searchText)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Then items is triggered once
        XCTAssertEqual(itemsResult.events.count, 1)
        
        // And it is empty
        XCTAssertEqual(itemsResult.events.last!.value.element!.count, 0)
        
        // openWeatherMapService's getWeatherForecast is called once and param is correct
        XCTAssertEqual(openWeatherMapService.timesThatGetWeatherForecastCalled, 1)
        XCTAssertEqual(openWeatherMapService.paramOfGetWeatherForecast, "sai")
    }
    
    func test_makeWeatherForecastViewModel() throws {
        let dailyForecastItem = DailyForecastItem(date: 1614488400,
                                                  pressure: 1010,
                                                  humidity: 38,
                                                  weathers: [Weather(description: "sky is clear")],
                                                  temperature: Temperature(min: 23.43, max: 35.11))
        let output = DefaultWeatherForecastListViewModel.makeWeatherForecastViewModel(with: dailyForecastItem)
        
        XCTAssertEqual(output.date, "Date: Sun, 28 Feb 2021")
        XCTAssertEqual(output.averageTemperature, "Average Temperature: 29°C")
        XCTAssertEqual(output.pressure, "Pressure: 1010")
        XCTAssertEqual(output.humidity, "Humidity: 38%")
        XCTAssertEqual(output.description, "Description: sky is clear")
    }
}
