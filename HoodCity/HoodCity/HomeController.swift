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
    
    lazy var firebaseClient: FirebaseClient = {
        return FirebaseClient()
    }()
    
    var mapHasCenteredOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        
        let location = locationManager.currentLocation()
        
        if let location = location {
            showEvents(at: location)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.getAuthStatus()
    }

    @IBAction func newEvent(_ sender: UIButton) {
        //let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        guard let location = locationManager.currentLocation() else { return }
        
        let timeStamp = "\(Int(NSDate.timeIntervalSinceReferenceDate * 100000))"
        
        geoFireClient.createSighting(for: location, with: timeStamp)
        firebaseClient.addEvent(withID: timeStamp)
        firebaseClient.addDateToEvent(eventID: timeStamp)
    }
    
    // Show events on the map
    
    func showEvents(at location: CLLocation) {
        geoFireClient.showEvents(at: location) { (geoFireData, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            let eventId = geoFireData!.0
            let location = geoFireData!.1
            
            let annotation = EventAnnotation(coordinate: location.coordinate)
            self.mapView.addAnnotation(annotation)
            
            let eventInformation = EventInformation(eventId, annotation)
            self.isEventExpired(eventInformation)
        }
    }
    
    typealias EventInformation = (String, EventAnnotation)
    
    func remove(_ eventInformation: EventInformation) {
        let key = eventInformation.0
        let annotation = eventInformation.1
        
        geoFireClient.remove(key) { (error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            self.mapView.removeAnnotation(annotation)
        }
    }
    
    func isEventExpired(_ eventInformation: EventInformation) {
        let eventId = eventInformation.0
        
        firebaseClient.dateOf(eventID: eventId, completionHandler: { (eventDate, error) in
            if error != nil {
                print(error!)
            } else {
                let currentDate = Date()
                let interval = currentDate.timeIntervalSince(eventDate!)
                
                let hoursSinceEvent = interval / 3600
                
                if hoursSinceEvent > 12.0 {
                    self.remove(eventInformation)
                }
            }
        })
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Event")
        print("called")
        return annotationView
    }
    
}




