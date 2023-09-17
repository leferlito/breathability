//
//  SearchService.swift
//  breathability
//
//  Created by Lauren Ferlito on 9/14/23.
//

import Foundation

struct SearchService {
    private let session: URLSession = .shared
    
    public func search(latitude: Double?, longitude: Double?) async throws -> AQIModel {
        // Don't want lat and lon to be optional
        guard let latitude = latitude, let longitude = longitude else {
            fatalError("Invalid URL, lat or long is nil")
        }
        let components = URLComponents(string: "https://api.airvisual.com/v2/nearest_city?lat=\(latitude)&lon=\(longitude)&key=4f1ae6ab-1975-4949-87b6-158379adc7b9")

        guard let url = components?.url else { fatalError("Invalid URL") }
        print(url)

        let (data, _) = try await session.data(from: url) // Extract the data component
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let aqiModel = try decoder.decode(AQIModel.self, from: data) // Pass the data
        return aqiModel
    }
}

