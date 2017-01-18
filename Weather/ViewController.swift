//
//  ViewController.swift
//  Weather
//
//  Created by FSMIS on 2017/1/18.
//  Copyright © 2017年 FSMIS. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import Foundation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loading: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        loadingIndicator.startAnimating()
        view.backgroundColor = UIColor(patternImage: UIImage(named:"IMG_3355.JPG")!)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]

        if location.horizontalAccuracy > 0 {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude

            self.updateWeatherInfo(latitude, longitude: longitude)
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.loading.text = "地理位置不可用"
    }

    func updateWeatherInfo(_ latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlStr = "http://api.openweathermap.org/data/2.5/weather"
        let params = ["lat": latitude, "lon": longitude, "appid": "c207c962b614f9b371696d18ed651d36"] as [String : Any]
        Alamofire.request(urlStr, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (dataresponse) in
            switch dataresponse.result {
            case .success(let jsonStr):
                let json = JSON(jsonStr)
                let locationName = json["name"].stringValue
                self.locationName.text = locationName
                let id = json["weather"][0]["id"].intValue
                var temp = json["main"]["temp"].doubleValue
                temp -= 273.15
                self.loading.text = nil
                self.temp.text = "\(temp)℃"
                self.updateWeatherIcon(condition: id)
            case .failure(_): self.loading.text = "地理位置不可用"
            }
        }
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }

    func updateWeatherIcon(condition: Int) {
        var image = UIImage()
        switch condition {
        case 200..<300: image = UIImage(named: "tick_weather_036.png")!
        case 300..<400: image = UIImage(named: "tick_weather_019.png")!
        case 500..<600: image = UIImage(named: "tick_weather_038.png")!
        case 600..<700: image = UIImage(named: "tick_weather_026.png")!
        case 700..<800: image = UIImage(named: "tick_weather_015.png")!
        case 800: image = UIImage(named: "tick_weather_032.png")!
        case 800..<900: image = UIImage(named: "tick_weather_003.png")!
        default: image = UIImage(named: "tick_weather_010.png")!
        }
        self.icon.image = image
    }

}

