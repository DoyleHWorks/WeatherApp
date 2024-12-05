//
//  TableViewCell.swift
//  WeatherApp
//
//  Created by t0000-m0112 on 2024-12-05.
//

import UIKit
import SnapKit
import Then

final class TableViewCell: UITableViewCell {
    
    static let id = "TableViewCell"
    
    private let dtTxtLabel = UILabel().then {
        $0.backgroundColor = .black
        $0.textColor = .white
    }
    
    private let tempLabel = UILabel().then {
        $0.backgroundColor = .black
        $0.textColor = .white
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    // Code for initialization with interface builder
    // fatalError explicitly means that the initialization will not be done with interface builder
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.backgroundColor = .black
        [
            dtTxtLabel,
            tempLabel
        ].forEach { contentView.addSubview($0) }
        
        dtTxtLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        tempLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    public func configureCell(forecastWeather: ForecastWeather) {
        dtTxtLabel.text = "\(forecastWeather.dtTxt)"
        tempLabel.text = "\(forecastWeather.main.temp)°C"
    }
}
