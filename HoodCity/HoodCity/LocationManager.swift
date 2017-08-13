//
//  LocationManager.swift
//  HoodCity
//
//  Created by Iván Martínez on 11/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation
import MapKit

protocol LocationManagerDelegate: class {
    func locationManagerDidChangeAuthorization(status: CLAuthorizationStatus)
}

class LocationManager: NSObject {
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        
        return manager
    }()
    
    let mapView: MKMapView?
    
    var delegate: LocationManagerDelegate?
    
    init(mapView: MKMapView?) {
        self.mapView = mapView
    }
    
    // Helper
    
    func authorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 5000, 5000)
        
        mapView?.setRegion(coordinateRegion, animated: false)
    }

    func currentLocation() -> CLLocation? {
        return locationManager.location
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.locationManagerDidChangeAuthorization(status: status)
    }
    
}
