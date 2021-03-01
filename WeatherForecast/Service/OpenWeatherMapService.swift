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
        struct OpenWeatherMapAPI {
            static let scheme = "https"
            static let host = "api.openweathermap.org"
            static let path = "/data/2.5/forecast/daily"
            static let apiKey = "60c6fbeb4b93ac653c492ba806fc346d"
            
            struct Parameters {
                static let q = "q"
                static let appid = "appid"
                
                static let cnt = "cnt"
                static let cntValue = "7"
                
                static let units = "units"
                static let unitsValue = "metric"
            }
        }
    }
    
    let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func getWeatherForecast(withQuery query: String) -> Observable<Result<DailyForecastList, Error>> {
        
        return Observable<Result<DailyForecastList, Error>>.create { [unowned self] observer in
            let url = self.makeWeatherDailyForecastURL(withQuery: query)
            let urlRequest = URLRequest(url: url,
                                        cachePolicy: .returnCacheDataElseLoad,
                                        timeoutInterval: TimeInterval(300))
            
            let task = self.urlSession.dataTask(with: urlRequest) { data, response, error in
                
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
                    if let dailyForcast = try? decoder.decode(DailyForecastList.self, from: data) {
                        observer.onNext(.success(dailyForcast))
                    } else {
                        observer.onNext(.failure(NSError()))
                    }
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
    
    func makeWeatherDailyForecastURL(withQuery query: String) -> URL {
        var components = URLComponents()
        components.scheme = Constants.OpenWeatherMapAPI.scheme
        components.host = Constants.OpenWeatherMapAPI.host
        components.path = Constants.OpenWeatherMapAPI.path
        
        components.queryItems = [
            URLQueryItem(name: Constants.OpenWeatherMapAPI.Parameters.q, value: query),
            URLQueryItem(name: Constants.OpenWeatherMapAPI.Parameters.cnt, value: Constants.OpenWeatherMapAPI.Parameters.cntValue),
            URLQueryItem(name: Constants.OpenWeatherMapAPI.Parameters.appid, value: Constants.OpenWeatherMapAPI.apiKey),
            URLQueryItem(name: Constants.OpenWeatherMapAPI.Parameters.units, value: Constants.OpenWeatherMapAPI.Parameters.unitsValue)
        ]
        
        guard let url = components.url else {
            fatalError("Can't create daily forcast url")
        }
        
        return url
    }
}
