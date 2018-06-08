//
//  Structures.swift
//  WeatherSchmeather
//
//  Created by Aritro Paul on 15/04/18.
//  Copyright © 2018 NotACoder. All rights reserved.
//

import Foundation
import UIKit

func getTime()->Int{
    let formatHour = DateFormatter()
    formatHour.dateFormat = "HH"
    let date = Date()
    let currentHour = formatHour.string(from: date)
    return Int(currentHour)!
}

let dark = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)

struct Main: Decodable{
    let temp: Double?
    let pressure: Double?
    let humidity: Double?
}

struct Wind:Decodable {
    let speed: Double?
    let deg: Double?
}
struct Weather:Decodable{
    let id: Int?
    let name: String?
    let main: Main?
    let wind: Wind?
    let weather: [WeatherArray]?
}

struct WeatherArray:Decodable{
    var main : String?
    var description : String?
}


func calculateWindAngle(angle: Double)->String?{
    
    var caridnals = [ "North", "North-East", "East", "South-East", "South", "South-West", "West", "North-West", "North" ];
    let val = angle.truncatingRemainder(dividingBy: 360)/45
    
    return caridnals[Int(val)]
    
}


