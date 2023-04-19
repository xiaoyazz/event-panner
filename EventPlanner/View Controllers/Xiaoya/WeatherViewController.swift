//
//  WeatherViewController.swift
//  EventPlanner
//
//  Created by Xiaoya Zou (9901617988) on 2023-04-18.
//  Self research & learn feature
//  This weather view is to show current weather of Toronto
//  Call openweathermap api to show current weather data
//  Change the background color & icons dynamically
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherImageView:UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Call API Key for Toronto
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=43.651070&lon=-79.34&appid=84f4dde0ea6a0bf2e3864301871f625e&units=metric") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let data = data, error == nil {
                
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] else { return }
                    
                    guard let weatherDetails = json["weather"] as? [[String : Any]], let weatherMain = json["main"] as? [String : Any] else { return }
                    
                    let temp = Int(weatherMain["temp"] as? Double ?? 0)
                    
                    let description = (weatherDetails.first?["description"] as? String)?.capitalizingFirstLetter()
                    
                    DispatchQueue.main.async {
                        self.setWeather(weather: weatherDetails.first?["main"] as? String, description: description, temp : temp)
                    }
                } catch {
                    print("We had an error retrieving the weather data")
                }
            }
        }
        task.resume()
    }
    
    // Match weather icons and colors
    func setWeather(weather: String?, description: String?, temp: Int){
        
        weatherDescriptionLabel.text = description ?? "..."
        tempLabel.text = "\(temp)°"
        switch weather {
        case "Sunny":
            weatherImageView.image = UIImage(named: "sunny")
            background.backgroundColor = UIColor(red: 0.898, green: 0.6745, blue: 0, alpha: 1.0)
        default:
            weatherImageView.image = UIImage(named: "cloud")
            background.backgroundColor = UIColor(red: 0, green: 0.7686, blue: 0.7294, alpha: 1.0)
        }
    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

}
