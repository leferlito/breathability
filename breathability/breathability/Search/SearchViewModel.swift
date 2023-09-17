//
//  SearchViewModel.swift
//  breathability
//
//  Created by Lauren Ferlito on 9/14/23.
//


import Foundation
import SwiftUI

enum LocationLoadingState {
    case idle
    case loading
    case success(AQIModel)
    case error(String)
}

@MainActor
class SearchViewModel: ObservableObject {
    private let locationManager = LocationManager()
    private let service = SearchService()
    
    @Published var state: LocationLoadingState = .idle
    
    init() {
        locationManager.delegate = self
    }
    
    func requestLocation() {
        state = .loading
        locationManager.requestLocation()
    }
    
    func search(latitude: Double, longitude: Double) {
        Task{
            do{
                let aqis = try await service.search(latitude: latitude, longitude: longitude)
                state = .success(aqis)
            } catch{
                state = .error(error.localizedDescription)
                print(error)
            }
        }
    }
}

extension SearchViewModel: LocationManagerDelegate {
    func locationManager(_ manager: LocationManager, didUpdateLocation location: LocationModel) {
        search(latitude: location.latitude, longitude: location.longitude)
    }
    
    func locationManager(_ manager: LocationManager, didFailError error: Error) {
        state = .error(error.localizedDescription)
    }
}

extension SearchViewModel {
    func airQualityAssessment(aqi: Int) -> String {
        var result: String
        
        if aqi <= 50 {
            result = "Air quality is satisfactory and poses little or no risk to the general population."
        } else if aqi <= 100 {
            result = "Air quality is acceptable; however, there may be a concern for some people who are unusually sensitive to air pollution."
        } else if aqi <= 150 {
            result = "Members of sensitive groups (e.g., children, elderly, individuals with respiratory or heart conditions) may experience health effects. The general public is not likely to be affected."
        } else if aqi <= 200 {
            result = "Everyone may begin to experience health effects; members of sensitive groups may experience more serious health effects."
        } else if aqi <= 300 {
            result = "Health alert: everyone may experience more serious health effects."
        } else {
            result = "Health warning of emergency conditions. The entire population is likely to be affected."
        }
        
        return result
    }
    
    func iconSelection(aqi: Int) -> String {
        var icon: String
        
        if aqi <= 50 {
            icon = "face.smiling"
        } else if aqi <= 100 {
            icon = "hand.thumbsup"
        } else if aqi <= 150 {
            icon = "figure.roll"
        } else if aqi <= 200 {
            icon = "allergens"
        } else if aqi <= 300 {
            icon = "facemask"
        } else {
            icon = "exclamationmark.circle"
        }
        
        return icon
    }
    
    func colorSelection(aqi: Int) -> Color {
        var color: Color
        
        if aqi <= 50 {
            color = Color.green
        } else if aqi <= 100 {
            color = Color.yellow
        } else if aqi <= 150 {
            color = Color.orange
        } else if aqi <= 200 {
            color = Color.pink
        } else if aqi <= 300 {
            color = Color.purple
        } else {
            color = Color.red
        }
        
        return color
    }
}
