# WeatherForecast

An small app displays weather daily forecast for cities.

## Architecure

- We use MVVM architecture and reactive programming with RxSwift.
- Design patterns: Dependency injection

<img width="689" alt="Screen Shot 2021-03-02 at 1 48 59 AM" src="https://user-images.githubusercontent.com/37906969/109543968-8dd62880-7af9-11eb-90c2-001c07a52bc2.png">


## Code folder structure

- Service: Contains only 1 class DefaultOpenWeatherMapService which handles OpenWeatherMap API.
- Models: Contains business model classes
- WeatherForecastList: Contains the view controller and the view model for the screen
  - WeatherForecastCell: Contains the table view cell and the view model of the cell.

## Frameworks we used

- RxSwift https://github.com/ReactiveX/RxSwift

## How to run the app

1. Clone this repository.
2. Install dependencies: `pod install`
3. Open `WeatherForecast.xcworkspace` in XCode 12 or above and run it

