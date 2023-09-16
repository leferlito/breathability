//
//  SearchViewModel.swift
//  breathability
//
//  Created by Lauren Ferlito on 9/14/23.
//


import Foundation

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
    func locationManager(_ manager: LocationManager, didUpdateLocation location: Location) {
        search(latitude: location.latitude, longitude: location.longitude)
    }
    
    func locationManager(_ manager: LocationManager, didFailError error: Error) {
        state = .error(error.localizedDescription)
    }
}

