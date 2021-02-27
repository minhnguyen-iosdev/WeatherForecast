//
//  WeatherForecastCell.swift
//  WeatherForecast
//
//  Created by Minh Nguyen on 2/27/21.
//

import UIKit

class WeatherForecastCell: UITableViewCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var averageTemperatureLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with viewModel: WeatherForecastViewModel) {
        dateLabel.text = viewModel.date
        averageTemperatureLabel.text = viewModel.averageTemperature
        pressureLabel.text = viewModel.pressure
        humidityLabel.text = viewModel.humidity
        descriptionLabel.text = viewModel.description
    }
}
