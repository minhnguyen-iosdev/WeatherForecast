//
//  WeatherForecastListViewController.swift
//  WeatherForecast
//
//  Created by Minh Nguyen on 2/27/21.
//

import UIKit

class WeatherForecastListViewController: UIViewController {
    struct Constants {
        static let estimatedRowHeight: CGFloat = 150
        static let screenTitle = "Weather Forecast"
    }
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchResultsTableView: UITableView!
    
    let items = [WeatherForecastViewModel(date: "Date: Mon, 04 May 2020",
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
    }
    
    func setupViews() {
        title = Constants.screenTitle
        setupSearchResultsTableView()
    }
    
    func setupSearchResultsTableView() {
        searchResultsTableView.register(UINib(nibName: String(describing: WeatherForecastCell.self), bundle: nil),
                                        forCellReuseIdentifier: String(describing: WeatherForecastCell.self))
        searchResultsTableView.dataSource = self
        searchResultsTableView.estimatedRowHeight = Constants.estimatedRowHeight
    }
}

extension WeatherForecastListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WeatherForecastCell.self),
                                                       for: indexPath) as? WeatherForecastCell else {
            return UITableViewCell()
        }
        
        cell.setup(with: items[indexPath.row])
        
        return cell
    }
}
