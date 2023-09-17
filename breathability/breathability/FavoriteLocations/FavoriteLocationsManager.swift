//
//  FavoriteLocationsManager.swift
//  breathability
//
//  Created by Lauren Ferlito on 9/15/23.
//

import Foundation

class FavoriteLocationsManager: ObservableObject {
    private let userDefaults = UserDefaults.standard
    let userDefaultsKey = "favorites"
  
    func addFavorite(cityName: String, coordinates: [Double]) {
        // add coordinates to corresponding key city
        UserDefaults.standard.set(coordinates, forKey: cityName)
        UserDefaults.standard.synchronize()
        
        // list of favorite city names
        // Before appending to the list, retrieve the existing list of strings from UserDefaults if it exists:
        var list = UserDefaults.standard.stringArray(forKey: userDefaultsKey) ?? []
        // Now, append a new string to the list if the new string is not already in the list:
        if !list.contains(cityName) {
            list.append(cityName)
            // Update UserDefaults with the updated list
            UserDefaults.standard.set(list, forKey: userDefaultsKey)
        } else {
            print("String already exists in the list.")
        }
    }
    
    func getCoordinates(cityName: String) -> [Double] {
        if let cityCoordinates = UserDefaults.standard.array(forKey: cityName) as? [Double] {
            return cityCoordinates
        } else {
            print("No value found for the key \(cityName)")
            return []
        }
    }
}
