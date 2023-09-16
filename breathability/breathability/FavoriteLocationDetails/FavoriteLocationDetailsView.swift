//
//  FavoriteLocationDetailsView.swift
//  breathability
//
//  Created by Lauren Ferlito on 9/16/23.
//

import SwiftUI

struct FavoriteLocationDetailsView: View {
    @StateObject private var favLocationsManager = FavoriteLocationsManager()
    @StateObject private var searchVM = SearchViewModel()
    let locationName: String

    init(locationName: String) {
        self.locationName = locationName
    }

    var body: some View {
        VStack {
            Text("Location Name: \(locationName)")
            let coordinates = favLocationsManager.getCoordinates(cityName: locationName)

            if !coordinates.isEmpty {
                let coordinatesString = coordinates.map { String($0) }.joined(separator: ", ")
                Text("Coordinates: \(coordinatesString)")
            } else {
                // Handle the case where coordinates couldn't be retrieved or converted
                Text("Coordinates not available")
            }
            Button("Find the AQI for \(locationName)") { searchVM.search(latitude: coordinates[1], longitude: coordinates[0])
            }
            switch searchVM.state {
            case .idle:
                Text("Please click the button above to make a aqi request")
            case .loading:
                ProgressView()
            case .success(let aqimodel):
                Text("\(aqimodel.data.city), \(aqimodel.data.state), \(aqimodel.data.country)")
                Text("Pollution = \(aqimodel.data.current.pollution.aqius) AQI")
                Text("Weather = \(aqimodel.data.current.weather.tp)•C")
            case .error(let error):
                Text(error)
                
            }
        }
    }
}

//struct FavoriteLocationDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoriteLocationDetailsView()
//    }
//}
