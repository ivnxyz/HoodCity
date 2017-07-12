//
//  HomeController.swift
//  HoodCity
//
//  Created by Iván Martínez on 11/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit
import MapKit

class HomeController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    lazy var locationManager: LocationManager = {
        return LocationManager(mapView: self.mapView)
    }()
    
    lazy var geoFireClient: GeoFireClient = {
        return GeoFireClient()
    }()
    
    var mapHasCenteredOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        showEvents(with: location)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.getAuthStatus()
    }

    @IBAction func newEvent(_ sender: UIButton) {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        let id = "\(arc4random_uniform(151) + 1)"
        
        geoFireClient.createSighting(for: location, with: id)
    }
    
    // Show events on the map
    
    func showEvents(with location: CLLocation) {
        geoFireClient.showEvents(at: location) { (geoFireData, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            // let key = geoFireData!.0
            let location = geoFireData!.1
            
            let annotation = EventAnnotation(coordinate: location.coordinate)
            
            self.mapView.addAnnotation(annotation)
        }
    }

}

extension HomeController: MKMapViewDelegate {
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let location = userLocation.location else { return }
        
        if !mapHasCenteredOnce {
            locationManager.centerMapOnLocation(location)
            mapHasCenteredOnce = true
        }
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        showEvents(with: location)
    }
    
}




