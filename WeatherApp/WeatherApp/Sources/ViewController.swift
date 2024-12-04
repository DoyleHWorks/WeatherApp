//
//  ViewController.swift
//  WeatherApp
//
//  Created by t0000-m0112 on 2024-12-04.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        printAPPID()
    }

    private func printAPPID() {
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPENWEATHER_APP_ID") as? String {
            print("API Key: \(apiKey)")
        } else {
            print("OPENWEATHER_APP_ID is not set or couldn't be read")
        }
    }
}

