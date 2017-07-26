//
//  HomeController.swift
//  HoodCity
//
//  Created by Iván Martínez on 11/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit
import MapKit
import Firebase

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
        
        print("view did load")
        
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
        
        let controller = EventController()
        controller.modalPresentationStyle = .overCurrentContext
        
        present(controller, animated: false, completion: nil)
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
            
            let eventInformation = EventInformation(eventId, location)
            
            print("EVENT: \(eventId)")
            self.isEventExpired(eventInformation)
        }
    }
    
    typealias EventInformation = (String, CLLocation)
    
    func remove(_ eventInformation: EventInformation) {
        let key = eventInformation.0
        
        geoFireClient.remove(key) { (error) in
            guard error == nil else {
                print(error!)
                return
            }
        }
    }
    
    func isEventExpired(_ eventInformation: EventInformation) {
        let eventId = eventInformation.0
        let location = eventInformation.1
        
        firebaseClient.getDate(from: eventId, completionHandler: { (eventDate, error) in
            if error != nil {
                print(error!)
            } else {
                let currentDate = Date()
                let interval = currentDate.timeIntervalSince(eventDate!)
                
                let hoursSinceEvent = interval / 3600
                
                if hoursSinceEvent > 12.0 {
                    self.remove(eventInformation)
                } else {
                    self.firebaseClient.getType(from: eventId, completionHandler: { (event) in
                        let annotation = EventAnnotation(coordinate: location.coordinate, eventType: event)
                        print("ANNOTATION: \(annotation)")
                        self.mapView.addAnnotation(annotation)
                    })
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
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        guard let eventAnnotation = annotation as? EventAnnotation else { return nil }
        
        var annotationView: EventAnnotationView?
        
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "EventAnnotation") as? EventAnnotationView {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        } else {
            annotationView = EventAnnotationView(eventAnnotation: eventAnnotation, reuseIdentifier: "EventAnnotation")
        }
        
        annotationView?.frame.size = CGSize(width: 30.0, height: 30.0)
        
        print("Creating AnnotationView")
        return annotationView
    }
    
}
