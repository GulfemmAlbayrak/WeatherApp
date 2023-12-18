//
//  HourlyWeatherVC.swift
//  WeatherApp
//
//  Created by Gülfem Albayrak on 29.04.2023.
//

import UIKit

class CityVC: UIViewController{
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var showButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showButton.layer.cornerRadius = 10
}
    
    
    
    
    
    @IBAction func buttonTapped(_ sender: Any) {
        let city = cityTextField.text ?? ""
        if city.isEmpty{
            
            let alert = UIAlertController(title: "UYARI!", message: "Please enter city name.", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelButton)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let vc = self.storyboard?.instantiateViewController(identifier: "CityDetailVC") as! CityDetailVC
            vc.city = city
            self.show(vc, sender: nil)
            
           
            }
        }
    }



    


