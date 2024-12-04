//
//  ViewController.swift
//  WeatherApp
//
//  Created by t0000-m0112 on 2024-12-04.
//

import UIKit
import SnapKit
import Then

class ViewController: UIViewController {
    
    private let titleLabel = UILabel().then {
        $0.text = "Seoul"
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
        $0.backgroundColor = .gray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func printAPPID() {
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPENWEATHER_APP_ID") as? String {
            print("API Key: \(apiKey)")
        } else {
            print("OPENWEATHER_APP_ID is not set or couldn't be read")
        }
    }
    
    // MARK: Fetch data from server
    private func fecthData<T: Decodable>(url: URL, completion: @escaping ((T?) -> Void)) {
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
    
    
    // MARK: - UI Configurations
    private func configureUI() {
        view.backgroundColor = .black
        [
            titleLabel,
            tempLabel,
            tempStackView,
            imageView
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
    }
}

