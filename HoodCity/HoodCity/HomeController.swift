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
    
    var mapHasCenteredOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.userTrackingMode = .follow
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.getAuthStatus()
    }

    @IBAction func newEvent(_ sender: UIButton) {
        
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
    
}
