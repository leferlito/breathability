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
                if (isShowingFavorites == true) {
                    NavigationLink("", destination: FavoriteLocationsView(), isActive: $isShowingFavorites)
                }
                switch vm.state {
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
                        let safety = vm.airQualityAssessment(aqi: aqimodel.data.current.pollution.aqius)
                        let icon = vm.iconSelection(aqi: aqimodel.data.current.pollution.aqius)
                        let color = vm.colorSelection(aqi: aqimodel.data.current.pollution.aqius)
                        Image(systemName: icon)
                            .foregroundColor(color)
                            .font(.system(size: 30))
                            .padding(.bottom, 2)
                        Text(safety)
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                        Button {
                            favLoc.addFavorite(cityName: aqimodel.data.city, coordinates: aqimodel.data.location.coordinates)
                            isShowingFavorites = true
                        } label: {
                            Text("Add \(aqimodel.data.city) as a favorite location")
                        }
                    }
                case .error(let error):
                    Text(error)
                    
                }
                Button("View your favorite locations") {
                    isShowingFavorites = true
                } .padding(.leading, 50)
            }
            .navigationTitle("Breathability")
        } .onAppear {
            vm.requestLocation()
            
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
