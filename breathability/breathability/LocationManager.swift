//
//  LocationManager.swift
//  breathability
//
//  Created by Lauren Ferlito on 9/14/23.
//

import Foundation
import CoreLocation
import Combine

// MARK: LocationManagerDelegate

protocol LocationManagerDelegate: AnyObject {
    func locationManager(_ manager: LocationManager, didUpdateLocation location: LocationModel)
    func locationManager(_ manager: LocationManager, didFailError error: Error)
}

// MARK: LocationManager - contains logic to find current location

class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    
    // The delegate object we'll send locations or errors to when we receive them from CLLocationManager
    // Note: Captures a weak reference to the object to avoid a retain cycle:
    weak var delegate: LocationManagerDelegate?
    
    private var locationPublisher = PassthroughSubject<LocationModel, Never>()
    private var subscriber: AnyCancellable?
    
    override init() {
        super.init()
        
        // Set self as the locationManager's delegate
        // - Allows the locationManager to send data to this instance
        locationManager.delegate = self

        // Set the desired location accuracy
        // - Not all apps need super precise location
        // - Sometimes it's okay to only know location to the nearest kilometer
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation

        // Set the minimum distance (in meters) required to send a new location event
        // - We need this since we're now using `startUpdatingLocations`, which can send many
        //   location updates. But, this distance filter should make it so we don't get
        //   too many sequential updates per request
        locationManager.distanceFilter = 5
        
        // Ask the user to give us permission to access their location
        // - This will present the "Allow `app name` to use your location?"
        //   popup that we've all seen a thousand times
        locationManager.requestWhenInUseAuthorization()
        
        // Set up a subscriber that prevents many notifications to the delegate within a small amount of time
        // - The debounce operator will ignore events from the publisher if it happens within 0.25s of the last one
        // - Then, we subscribe to the pipeline and call the delegate's `didUpdateLocation` method
        subscriber = locationPublisher
            .debounce(for: 0.25, scheduler: RunLoop.main)
            .sink { [weak self] location in
                guard let self = self else { return }
                self.delegate?.locationManager(self, didUpdateLocation: location)
            }
    }
    
    func requestLocation() {
        locationManager.startUpdatingLocation()
    }
}

// MARK: Delegate Conformance

extension LocationManager: CLLocationManagerDelegate {
    /// Called by `CLLLocationManager` when there is a successful locations update
    /// - The `locations` array will always have at least one element inside, and if there are multiple the most recent is the
    ///   most reliable/recent: https://developer.apple.com/documentation/corelocation/cllocationmanagerdelegate/1423615-locationmanager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let clLocation = locations.last else { return }
        let location = LocationModel(latitude: clLocation.coordinate.latitude, longitude: clLocation.coordinate.longitude)

        locationPublisher.send(location)
        locationManager.stopUpdatingLocation()
    }
    
    /// Called by `CLLocationManager` when there is an error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationManager(self, didFailError: error)
        locationManager.stopUpdatingLocation()
    }
}
