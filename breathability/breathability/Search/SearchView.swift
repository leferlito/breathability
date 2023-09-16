//
//  SearchView.swift
//  breathability
//
//  Created by Lauren Ferlito on 9/14/23.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var vm = SearchViewModel()
    @StateObject private var favLoc = FavoriteLocationsManager()
    @State private var isShowingFavorites = false // A boolean to control navigation
    
    var body: some View {
        NavigationView {
            List {
                Button("Find the AQI for your location") { vm.requestLocation() }
                if (isShowingFavorites == true) {
                    NavigationLink("", destination: FavoriteLocationsView(), isActive: $isShowingFavorites)
                }
                switch vm.state {
                case .idle:
                    Text("Please click the button above to make a aqi request")
                case .loading:
                    ProgressView()
                case .success(let aqimodel):
                    Text("\(aqimodel.data.city), \(aqimodel.data.state), \(aqimodel.data.country)")
                    Text("Pollution = \(aqimodel.data.current.pollution.aqius) AQI")
                    Text("Weather = \(aqimodel.data.current.weather.tp)•C")
                    Button {
                        favLoc.addFavorite(cityName: aqimodel.data.city, coordinates: aqimodel.data.location.coordinates)
                        isShowingFavorites = true
                    } label: {
                        Text("Add \(aqimodel.data.city) as a favorite location")
                    }
                case .error(let error):
                    Text(error)
                    
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
