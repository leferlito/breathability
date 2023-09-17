//
//  FavoriteLocationsView.swift
//  breathability
//
//  Created by Lauren Ferlito on 9/15/23.
//

import SwiftUI

struct FavoriteLocationsView: View {
    @State private var favCityList: [String] = []
    let userDefaultsKey = "favCitiesList"
    
    var body: some View {
        List(favCityList, id: \.self) { city in
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

struct FavoriteLocationsView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteLocationsView()
    }
}
