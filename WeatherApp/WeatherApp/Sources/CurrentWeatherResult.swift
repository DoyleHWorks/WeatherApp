//
//  CurrentWeatherResult.swift
//  WeatherApp
//
//  Created by t0000-m0112 on 2024-12-04.
//

import Foundation

struct CurrentWeatherResult: Codable {
    let weather: [Weather]
    let main: WeatherMain
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct WeatherMain: Codable {
    let temp: Double
//    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
//    let pressure: Int
//    let humidity: Int
//    let seaLevel: Int
//    let grndLevel: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
//        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
//        case pressure
//        case humidity
//        case seaLevel = "sea_level"
//        case grndLevel = "grnd_level"
    }
}
