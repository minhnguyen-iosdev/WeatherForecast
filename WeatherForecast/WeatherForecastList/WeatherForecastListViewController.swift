//
//  WeatherForecastListViewController.swift
//  WeatherForecast
//
//  Created by Minh Nguyen on 2/27/21.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherForecastListViewController: UIViewController {
    struct Constants {
        static let estimatedRowHeight: CGFloat = 150
        static let screenTitle = "Weather Forecast"
    }
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchResultsTableView: UITableView!
    lazy var searchResultsTableViewDataSource = makeDataSource()
    let openWeatherMapService: OpenWeatherMapService = DefaultOpenWeatherMapService()
    
    let searchText = BehaviorRelay<String>(value: "")
    let disposeBag = DisposeBag()
    
    var items = [WeatherForecastViewModel(date: "Date: Mon, 04 May 2020",
                                          averageTemperature: "Average Temperature: 25C",
                                          pressure: "1020",
                                          humidity: "49%",
                                          description: "sky is clear"),
                 WeatherForecastViewModel(date: "Date: Tue, 05 May 2020",
                                          averageTemperature: "Average Temperature: 27C",
                                          pressure: "1060",
                                          humidity: "53%",
                                          description: "sky is clear")]
    
    init() {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateSearchResultsTableViewDataSource()
        
        searchText
            .filter { $0.count >= 3 }
            .debug("@@@", trimOutput: true)
            .flatMapLatest { [unowned self] text -> Observable<Result<DailyForecastList, Error>> in
                self.openWeatherMapService.getWeatherForecast(withQuery: text)
            }
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case let .success(dailyForecastList):
                    var newItems = [WeatherForecastViewModel]()
                    for item in dailyForecastList.list {
                        let viewModel = WeatherForecastViewModel(date: item.date.description,
                                                                 averageTemperature: String(item.temperature.min),
                                                                 pressure: String(item.pressure),
                                                                 humidity: String(item.humidity),
                                                                 description: String(item.weathers[0].description))
                        newItems.append(viewModel)
                    }
    
                    self.items = newItems
                    self.updateSearchResultsTableViewDataSource()
                default: break
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    func setupViews() {
        title = Constants.screenTitle
        searchBar.delegate = self
        setupSearchResultsTableView()
    }
    
    func setupSearchResultsTableView() {
        searchResultsTableView.register(UINib(nibName: String(describing: WeatherForecastCell.self), bundle: nil),
                                        forCellReuseIdentifier: String(describing: WeatherForecastCell.self))
        searchResultsTableView.dataSource = searchResultsTableViewDataSource
        searchResultsTableView.estimatedRowHeight = Constants.estimatedRowHeight
    }
}

extension WeatherForecastListViewController {
    enum Section {
        case main
    }
    
    func makeDataSource() -> UITableViewDiffableDataSource<Section, WeatherForecastViewModel> {
        return UITableViewDiffableDataSource(
            tableView: searchResultsTableView,
            cellProvider: {  tableView, indexPath, viewModel in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WeatherForecastCell.self),
                                                               for: indexPath) as? WeatherForecastCell else {
                    fatalError("Can't create a new WeatherForecastCell")
                }
                
                cell.setup(with: viewModel)
                
                return cell
            }
        )
    }
    
    func updateSearchResultsTableViewDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, WeatherForecastViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        searchResultsTableViewDataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension WeatherForecastListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText.accept(searchText)
    }
}
