//
//  OpenWeatherMapService.swift
//  WeatherForecast
//
//  Created by Minh Nguyen on 2/28/21.
//

import RxSwift
import RxCocoa

protocol OpenWeatherMapService {
    func getWeatherForecast(withQuery query: String) -> Observable<Result<DailyForecastList, Error>>
}

class DefaultOpenWeatherMapService: OpenWeatherMapService {
    private struct Constants {
        static let scheme = "https"
        static let host = "api.openweathermap.org"
        static let path = "/data/2.5/forecast/daily"
        static let apiKey = "60c6fbeb4b93ac653c492ba806fc346d"
    }
    
    func getWeatherForecast(withQuery query: String) -> Observable<Result<DailyForecastList, Error>> {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host
        components.path = Constants.path
        
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "cnt", value: "7"),
            URLQueryItem(name: "appid", value: Constants.apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        guard let url = components.url else {
            fatalError("Can't create url")
        }
        
        return Observable<Result<DailyForecastList, Error>>.create { observer in
            let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
                
                guard let response = response, let data = data else {
                    observer.onNext(.failure(error ?? NSError()))
                    observer.on(.completed)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    observer.onNext(.failure(NSError()))
                    observer.on(.completed)
                    return
                }

                if 200 ..< 300 ~= httpResponse.statusCode {
                    let decoder = JSONDecoder()
                    let _dailyForcast = try? decoder.decode(DailyForecastList.self, from: data)
                    let dailyForcast = _dailyForcast ?? DailyForecastList(cod: "", message: 0, cnt: 0, list: [])
                    observer.onNext(.success(dailyForcast))
                }
                else {
                    observer.onNext(.failure(NSError()))
                }
                observer.on(.completed)
            }

            task.resume()

            return Disposables.create(with: task.cancel)
        }
    }
}
