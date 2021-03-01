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
    
    let viewModel: WeatherForecastListViewModel
    let disposeBag = DisposeBag()
    
    init(viewModel: WeatherForecastListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
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
    
    func bindViewModel() {
        viewModel.output.items
            .subscribe(onNext: { [unowned self] items in
                self.updateSearchResultsTableView(with: items)
            })
            .disposed(by: disposeBag)
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
    
    func updateSearchResultsTableView(with items: [WeatherForecastViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, WeatherForecastViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        searchResultsTableViewDataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension WeatherForecastListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.input.searchText.accept(searchText)
    }
}
