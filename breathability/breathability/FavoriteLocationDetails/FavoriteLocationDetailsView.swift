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
        List{
            VStack {
                switch searchVM.state {
                case .idle:
                    Text("")
                case .loading:
                    ProgressView()
                case .success(let aqimodel):
                    VStack(alignment: .center) {
                        Text("Air Quality Index = \(aqimodel.data.current.pollution.aqius)")
                            .font(.title3)
                        Text("\(aqimodel.data.city), \(aqimodel.data.state), \(aqimodel.data.country)")
                            .padding(.bottom, 2)
                        let safety = searchVM.airQualityAssessment(aqi: aqimodel.data.current.pollution.aqius)
                        let icon = searchVM.iconSelection(aqi: aqimodel.data.current.pollution.aqius)
                        let color = searchVM.colorSelection(aqi: aqimodel.data.current.pollution.aqius)
                        Image(systemName: icon)
                            .foregroundColor(color)
                            .font(.system(size: 30))
                            .padding(.bottom, 2)
                        Text(safety)
                            .multilineTextAlignment(.center)
                    } .padding()
                        .padding(.bottom)
                case .error(let error):
                    Text(error)
                    
                }
            } .onAppear {
                let coordinates = favLocationsManager.getCoordinates(cityName: locationName)
                searchVM.search(latitude: coordinates[1], longitude: coordinates[0])
            }
        } .navigationTitle(locationName)
    }
}
