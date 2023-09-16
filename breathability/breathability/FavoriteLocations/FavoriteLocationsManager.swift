//
//  FavoriteLocationsManager.swift
//  breathability
//
//  Created by Lauren Ferlito on 9/15/23.
//

import Foundation

class FavoriteLocationsManager: ObservableObject {
    private let userDefaults = UserDefaults.standard
    
    let userDefaultsKey = "favCitiesList"
  
    func addFavorite(cityName: String, coordinates: [Double]) {
        // add coordinates to key city
        UserDefaults.standard.set(coordinates, forKey: cityName)
        UserDefaults.standard.synchronize()
        
        // Before appending to the list, you should retrieve the existing list of strings from UserDefaults if it exists:
        var list = UserDefaults.standard.stringArray(forKey: userDefaultsKey) ?? []
        // Now, you can append a new string to the list:
        // Check if the new string is not already in the list
        if !list.contains(cityName) {
            // Append the new string to the list
            list.append(cityName)
            // Update UserDefaults with the updated list
            UserDefaults.standard.set(list, forKey: userDefaultsKey)
            print("added city name to the list of cities")
        } else {
            print("String already exists in the list.")
        }
    }
    
    func getCoordinates(cityName: String) -> [Double] {
        if let cityCoordinates = UserDefaults.standard.array(forKey: cityName) as? [Double] {
            print(cityCoordinates)
            return cityCoordinates
        } else {
            print("No value found for the key \(cityName)")
            return []
        }
    }
}
