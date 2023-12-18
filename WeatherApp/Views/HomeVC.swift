//
//  ViewController.swift
//  WeatherApp
//
//  Created by Gülfem Albayrak on 29.04.2023.
//

import UIKit
import CoreLocation

class HomeVC: UIViewController,CLLocationManagerDelegate {
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var feelsLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var stackView: UIStackView! {
        didSet {
            stackView.layer.borderWidth = 1.5
            stackView.layer.cornerRadius = 20
            stackView.layer.shadowColor = UIColor.black.cgColor
            stackView.layer.shadowOpacity = 1
            stackView.layer.shadowRadius = 10
        }
    }
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty , currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
            
        }
    }
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        let api = "ff120318f7eb2ac752e37b1170425d32"
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(api)")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil {
                print("error")
            } else {
                if data != nil {
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
                        
                        DispatchQueue.main.async {
                          
                            if let cityName = jsonResponse!["name"] as? String {
                                self.currentCityLabel.text = String(cityName)
                            }
                            
                            if let sys = jsonResponse!["sys"] as? [String:Any], let sunrise = sys["sunrise"] as? TimeInterval, let sunset = sys["sunset"] as? TimeInterval {
                                let now = Date().timeIntervalSince1970
                                let isDayTime = now > sunrise && now < sunset
                                
                                if let weather = jsonResponse!["weather"] as? [[String: Any]], let firstWeather = weather.first {
                                    if let currentWeather = firstWeather["main"] as? String {
                                        self.weatherLabel.text = String(currentWeather)
                                        
                                    if let description = firstWeather["description"] as? String {
                                        self.descriptionLabel.text = String(description)
                                    }

                                        switch currentWeather {
                                            case "Clouds":
                                                self.imageView.image = isDayTime ? UIImage(named: "cloudy_day") : UIImage(named: "cloudy_night")
                                            case "Rain":
                                                self.imageView.image = isDayTime ? UIImage(named: "rainy_day") : UIImage(named: "rainy_night")
                                            case "Clear":
                                                self.imageView.image = isDayTime ? UIImage(named: "sunny_day") : UIImage(named: "clear_night")
                                            default:
                                                self.imageView.image = isDayTime ? UIImage(named: "bg_day") : UIImage(named: "bg_night")
                                        }
                                    }
                                }
                        }

                            if let main = jsonResponse!["main"] as? [String:Any] {
                                if let temp = main["temp"] as? Double {
                                    self.currentTempLabel.text = String("\(Int(temp-272.15)) ° ")
                                }
                                if let feels = main["feels_like"] as? Double{
                                    self.feelsLabel.text = String("\(Int(feels-272.15)) ° ")
                                }
                                if let tempMin = main["temp_min"] as? Double{
                                    self.minTempLabel.text = String("\(Int(tempMin-272.15)) °")
                                }
                                if let tempMax = main["temp_max"] as? Double{
                                    self.maxTempLabel.text = String("\(Int(tempMax-272.15)) ° ")
                                }
                            }
                            if let wind = jsonResponse!["wind"] as? [String:Any] {
                                if let speed = wind["speed"] as? Double {
                                    self.windSpeedLabel.text = String("\(Int(speed)) km/sa ")
                                }
                            }
                           
                            
                        }
                    } catch {
                        
                    }
                }
            }
            
        }
        task.resume()
        
        
    }

}



