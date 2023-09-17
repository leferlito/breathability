//
//  FavoriteLocationsView.swift
//  breathability
//
//  Created by Lauren Ferlito on 9/15/23.
//

import SwiftUI

struct FavoriteLocationsView: View {
    @State private var favCityList: [String] = []
    @State private var searchText = ""
    let userDefaultsKey = "favorites"

    var filteredCities: [String] {
        if searchText.isEmpty {
            return favCityList
        } else {
            return favCityList.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        VStack {
            SearchBar(searchText: $searchText)

            List(filteredCities, id: \.self) { city in
                NavigationLink(destination: FavoriteLocationDetailsView(locationName: city)) {
                    Text(city)
                }
            }
            .onAppear {
                if let storedList = UserDefaults.standard.stringArray(forKey: userDefaultsKey) {
                    favCityList = storedList
                }
            }
            .navigationTitle("Favorites")
        }
    }
}
