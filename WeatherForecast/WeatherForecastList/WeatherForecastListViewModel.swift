//
//  WeatherForecastListViewModel.swift
//  WeatherForecast
//
//  Created by Minh Nguyen on 3/1/21.
//

import RxSwift
import RxCocoa

protocol WeatherForecastListViewModel {
    var input: WeatherForecastListViewModelInput { get }
    var output: WeatherForecastListViewModelOutput { get }
}

protocol WeatherForecastListViewModelInput {
    var searchText: PublishRelay<String> { get }
}

protocol WeatherForecastListViewModelOutput {
    var items: Observable<[WeatherForecastViewModel]> { get }
}

class DefaultWeatherForecastListViewModel: WeatherForecastListViewModel {
    struct Input: WeatherForecastListViewModelInput {
        let searchText = PublishRelay<String>()
    }
    
    struct Output: WeatherForecastListViewModelOutput {
        let items: Observable<[WeatherForecastViewModel]>
    }
    
    let input: WeatherForecastListViewModelInput = Input()
    let output: WeatherForecastListViewModelOutput
    
    let disposeBag = DisposeBag()
    
    init(openWeatherMapService: OpenWeatherMapService) {
        let items = BehaviorRelay<[WeatherForecastViewModel]>(value: [])
        
        input.searchText
            .filter { $0.count >= 3 }
            .map { $0.lowercased() }
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { text -> Observable<Result<DailyForecastList, Error>> in
                openWeatherMapService.getWeatherForecast(withQuery: text)
            }
            .subscribe(onNext: { result in
                switch result {
                case let .success(dailyForecastList):
                    let newItems = dailyForecastList.list
                        .map { DefaultWeatherForecastListViewModel.makeWeatherForecastViewModel(with: $0) }
                    items.accept(newItems)
                default: break
                }
                
            })
            .disposed(by: disposeBag)
        
        
        output = Output(items: items.asObservable())
    }
    
    static func makeWeatherForecastViewModel(with dailyForecastItem: DailyForecastItem) -> WeatherForecastViewModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM yyyy"
        
        let _date = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(dailyForecastItem.date)))
        let date = "Date: \(_date)"
        
        let _averageTemperature = (dailyForecastItem.temperature.min + dailyForecastItem.temperature.max) / 2
        let averageTemperature = "Average Temperature: \(Int(_averageTemperature.rounded()))°C"
        
        let pressure = "Pressure: \(dailyForecastItem.pressure)"
        let humidity = "Humidity: \(dailyForecastItem.humidity)%"
        let description = "Description: \(dailyForecastItem.weathers[0].description)"
        
        return WeatherForecastViewModel(date: date,
                                        averageTemperature: averageTemperature,
                                        pressure: pressure,
                                        humidity: humidity,
                                        description: description)
    }
}
