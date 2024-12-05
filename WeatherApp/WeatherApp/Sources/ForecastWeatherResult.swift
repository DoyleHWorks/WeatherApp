//
//  ForecastWeatherResult.swift
//  WeatherApp
//
//  Created by t0000-m0112 on 2024-12-05.
//

import Foundation

struct ForecastWeatherResult: Codable {
    let list: [ForecastWeather]
}

struct ForecastWeather :Codable {
    let main: WeatherMain
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case main
        case dtTxt = "dt_txt"
    }
}
