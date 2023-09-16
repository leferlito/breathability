//
//  Location.swift
//  breathability
//
//  Created by Lauren Ferlito on 9/14/23.
//

import Foundation

struct Location {
    let latitude: Double
    let longitude: Double
}

extension Location: CustomStringConvertible {
    var description: String {
        return "Latitude: \(latitude), Longitude: \(longitude)"
    }
}
