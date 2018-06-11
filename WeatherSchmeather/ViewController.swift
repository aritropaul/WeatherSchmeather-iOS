//
//  ViewController.swift
//  WeatherSchmeather
//
//  Created by Aritro Paul on 14/04/18.
//  Copyright © 2018 NotACoder. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var tapToChange: UILabel!
    @IBOutlet weak var locationDescLabel: UILabel!
    @IBAction func city(_ sender: Any) {
        updated = 0
        var cityName = locationLabel?.text
        let alert = UIAlertController(title: "Location", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter City"
        })
        let submitButton = UIAlertAction(title: "Done", style: .default, handler: { (action) -> Void in
            cityName = (alert.textFields?.first as! UITextField).text
            if (cityName?.contains(" "))!{
                cityName = cityName?.replacingOccurrences(of: " ", with: "%20")
                self.city = cityName!
            }
            self.locationLabel.text = cityName!
            if (self.locationLabel.text?.contains("%20"))!{
                self.locationLabel.text = self.locationLabel.text?.replacingOccurrences(of: "%20", with: " ")
            }
            self.getWeather()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alert.addAction(submitButton)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    var updated = 0
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var Temp: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var fahrenheitLabel: UIButton!
    @IBOutlet weak var celsiusLabel: UIButton!
    var FarhTemp = ""
    var CelsiusTemp = ""
    var timer = Timer()
    
    @IBAction func fahrenheitButton(_ sender: Any) {
        let mytheme = theme(time: getTime())
        tempLabel.text = "degrees fahrenheit"
        fahrenheitSelected(theme: mytheme)
        Temp.text = FarhTemp
        
    }
    @IBAction func celsiusButton(_ sender: Any) {
        let mytheme = theme(time: getTime())
        tempLabel.text = "degrees celsius"
        celsiusSelected(theme: mytheme)
        Temp.text = CelsiusTemp
    }
    @IBOutlet weak var locationForecast: UILabel!
    
    func celsiusSelected(theme: String){
        celsiusLabel.layer.cornerRadius = 5
        if(theme == "dark"){
        celsiusLabel.backgroundColor = UIColor.white
        celsiusLabel.setTitleColor(dark, for: .normal)
        fahrenheitLabel.backgroundColor = UIColor.clear
        fahrenheitLabel.setTitleColor(UIColor.white, for: .normal)
        }
        else{
            celsiusLabel.backgroundColor = dark
            celsiusLabel.setTitleColor(UIColor.white, for: .normal)
            fahrenheitLabel.backgroundColor = UIColor.clear
            fahrenheitLabel.setTitleColor(dark, for: .normal)
        }
        
    }
    
    func fahrenheitSelected(theme: String){
        fahrenheitLabel.layer.cornerRadius = 5
        if (theme == "dark"){
        fahrenheitLabel.backgroundColor = UIColor.white
        fahrenheitLabel.setTitleColor(dark, for: .normal)
        celsiusLabel.backgroundColor = UIColor.clear
        celsiusLabel.setTitleColor(UIColor.white, for: .normal)
        }
        else{
            fahrenheitLabel.backgroundColor = dark
            fahrenheitLabel.setTitleColor(UIColor.white, for: .normal)
            celsiusLabel.backgroundColor = UIColor.clear
            celsiusLabel.setTitleColor(dark, for: .normal)
        }
    }
    
    func changeScale(celsius: String)->String{
        let curTemp = Double(celsius)!
        
        let tempFar = curTemp*1.8 + 32
        return String(format: "%.1f",tempFar)
    }
    
    
    
    
    func Decoder(data: Data)->Weather?{

        let WeatherDecoder = JSONDecoder()
        do{
            let WeatherData = try WeatherDecoder.decode(Weather.self, from: data)
            return WeatherData
            
        }catch let err{
            print(err.localizedDescription)
        }
        return nil
    }
    
    
    @objc func getWeather()
    {
        var forecast = ""
        var  temp = ""
        var windDir = ""
        var Desc = ""
        let stringURL = "https://api.openweathermap.org/data/2.5/weather?q="+city+"&appid=YOUR_API_KEY"
        let url = URL(string: stringURL)!
        let request = NSMutableURLRequest(url: url)
        URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if let error = error{
                forecast = "Cannot find weather for "+self.city+". Please try again."
                print(error.localizedDescription)
                
            }
            else{
                if let data = data {
                    let weather = self.Decoder(data: data)
                    temp = String(format: "%.1f",(weather?.main?.temp)! - (273.15))
                    let angle = (weather?.wind?.deg)!
                    let speed = (weather?.wind?.speed)!
                    windDir = "There is a wind from the "+calculateWindAngle(angle: angle)!+" ."
                    Desc = weather?.weather![0].description!.capitalized ?? "N/A".capitalized
                    forecast = Desc + ". " + windDir
                }
            }
            DispatchQueue.main.sync(execute:{
                self.locationForecast?.text = forecast
                self.Temp.text = temp
                self.self.CelsiusTemp = temp
                self.FarhTemp = self.changeScale(celsius: self.CelsiusTemp)
            })
        }.resume()
        
        celsiusSelected(theme: theme(time: getTime()))
    }
    
    func theme(time: Int)->String{
        if(time > 6 && time < 18)
        {
            let newImage = UIImage(named: "locationDark.png")
            cityButton.setImage(newImage, for: .normal)
            view.backgroundColor = UIColor.white
            locationDescLabel.textColor = dark
            locationLabel.textColor = dark
            Temp.textColor = dark
            tempLabel.textColor = dark
            tapToChange.textColor = dark
            locationForecast.textColor = dark
            
            return "light"
        }
        else{
            let newImage = UIImage(named: "location.png")
            cityButton.setImage(newImage, for: .normal)
            view.backgroundColor = dark
            locationLabel.textColor = UIColor.white
            Temp.textColor = UIColor.white
            tempLabel.textColor = UIColor.white
            tapToChange.textColor = UIColor.white
            locationForecast.textColor = UIColor.white
            return "dark"
        }
    }
    
    var city = "Vellore"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getWeather()
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(getWeather), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

