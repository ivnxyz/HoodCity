//
//  LocationManager.swift
//  HoodCity
//
//  Created by Iván Martínez on 11/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation
import MapKit

class LocationManager: NSObject {
    
    private let locationManager = CLLocationManager()
    let mapView: MKMapView
    
    init(mapView: MKMapView) {
        self.mapView = mapView
    }
    
    func getAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 4000, 4000)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
}
