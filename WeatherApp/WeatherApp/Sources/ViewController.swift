//
//  ViewController.swift
//  WeatherApp
//
//  Created by t0000-m0112 on 2024-12-04.
//

import UIKit
import SnapKit
import Then
import Alamofire

class ViewController: UIViewController {
    
    private var dataSource = [ForecastWeather]()
    
    private let titleLabel = UILabel().then {
        $0.text = "Yangjae Station"
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 30)
    }
    private let tempLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "20°C"
        $0.font = .boldSystemFont(ofSize: 50)
    }
    private let tempMinLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "20°C"
        $0.font = .boldSystemFont(ofSize: 20)
    }
    private let tempMaxLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "20°C"
        $0.font = .boldSystemFont(ofSize: 20)
    }
    private let tempStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 20
        $0.distribution = .fillEqually
    }
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .black
    }
    private lazy var tableView = UITableView().then {
        $0.backgroundColor = .black
        $0.delegate = self
        $0.dataSource = self
        $0.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchCurrentWeatherData()
        fetchForecastData()
    }
    
    // MARK: - Fetch data from server
    private func fetchData<T: Decodable>(url: URL, completion: @escaping ((T?) -> Void)) {
        let session = URLSession(configuration: .default)
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, error == nil else {
                print("Data loading failed.")
                completion(nil)
                return
            }
            let successRange = 200..<300
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                    print("JSON decoding failed.")
                    completion(nil)
                    return
                }
                completion(decodedData)
            } else {
                print("Invalid response")
                completion(nil)
            }
        }.resume()
    }
    
    private func fetchDataByAF<T: Decodable>(url: URL, completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(url).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    private func makeURLQueryItems() -> [URLQueryItem] {
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPENWEATHER_APP_ID") as? String {
            //            print("API Key: \(apiKey)")
            return [
                URLQueryItem(name: "lat", value: "37.29"),
                URLQueryItem(name: "lon", value: "127.2"),
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "units", value: "metric")
            ]
        } else {
            print("OPENWEATHER_APP_ID is not set or couldn't be read")
            return []
        }
    }
    
    private func fetchCurrentWeatherData() {
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")
        urlComponents?.queryItems = self.makeURLQueryItems()
        
        guard let url = urlComponents?.url else {
            print("Invalid URL")
            return
        }
        
        //        print("Request URL: \(url.absoluteString)")
        
        fetchDataByAF(url: url) { [weak self] (result: Result<CurrentWeatherResult, AFError>) in
            guard let self else { return }
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.tempLabel.text = "\(Int(result.main.temp))°C"
                    self.tempMinLabel.text = "Min: \(Int(result.main.tempMin))°C"
                    self.tempMaxLabel.text = "Max: \(Int(result.main.tempMax))°C"
                }
                
                guard let imageUrl = URL(string: "https://openweathermap.org/img/wn/\(result.weather[0].icon)@2x.png") else {
                    return
                }
                
                AF.request(imageUrl).responseData { response in
                    if let data = response.data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.imageView.image = image
                        }
                    }
                }
                
            case .failure(let error):
                 print("Data load failed: \(error)")
            }
        }
    }
    
    private func fetchForecastData() {
        var urlComponents = URLComponents(string:"https://api.openweathermap.org/data/2.5/forecast")
        urlComponents?.queryItems = self.makeURLQueryItems()
        
        guard let url = urlComponents?.url else {
            print("Invalid URL")
            return
        }
        
        //        print("Request URL: \(url.absoluteString)")
        
        fetchDataByAF(url: url) { [weak self] (result: Result<ForecastWeatherResult, AFError>) in
            guard let self else { return }
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.dataSource = result.list
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print("Data load failed: \(error)")
            }
        }
    }
    
    // MARK: - UI Configurations
    private func configureUI() {
        view.backgroundColor = .black
        [
            titleLabel,
            tempLabel,
            tempStackView,
            imageView,
            tableView
        ].forEach { view.addSubview($0) }
        
        [
            tempMinLabel,
            tempMaxLabel
        ].forEach { tempStackView.addArrangedSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(120)
        }
        
        tempLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        tempStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(tempLabel.snp.bottom).offset(10)
        }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(160)
            $0.top.equalTo(tempStackView.snp.bottom).offset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(50)
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
}

extension ViewController: UITableViewDataSource {
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(forecastWeather: dataSource[indexPath.row])
        return cell
    }
}
