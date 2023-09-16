//
//  AQIModel.swift
//  breathability
//
//  Created by Lauren Ferlito on 9/14/23.
//

import Foundation

struct AQIModel: Codable {
    let status: String
    let data: AQIData
}

struct AQIData: Codable {
    let city: String
    let state: String
    let country: String
    let location: Location2
    let current: Current
}

struct Location2: Codable {
    let type: String
    let coordinates: [Double]
}

struct Current: Codable {
    let pollution: Pollution
    let weather: Weather
}

struct Pollution: Codable {
    let ts: String
    let aqius: Int
    let mainus: String
    let aqicn: Int
    let maincn: String
}

struct Weather: Codable {
    let ts: String
    let tp: Int
    let pr: Int
    let hu: Int
    let ws: Double
    let wd: Int
    let ic: String
}
