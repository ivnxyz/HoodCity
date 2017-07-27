//
//  MapController.swift
//  HoodCity
//
//  Created by Iván Martínez on 26/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit

class MapController: UIViewController {
    
    //MARK: - UI Elements
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        return mapView
    }()
    
    lazy var addEventButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "add-event-button"), for: .normal)
        button.addTarget(self, action: #selector(MapController.addNewEvent), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    //MARK: - Dependencies
    
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
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Near You"
        
        view.addSubview(mapView)
        view.addSubview(addEventButton)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addEventButton.heightAnchor.constraint(equalToConstant: 61),
            addEventButton.widthAnchor.constraint(equalToConstant: 61),
            addEventButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            addEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        
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
    
    //Add new event
    
    func addNewEvent() {
        
        let controller = EventController()
        controller.modalPresentationStyle = .overCurrentContext
        
        present(controller, animated: false, completion: nil)
    }
    
    //MARK: - Show Events
    
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

extension MapController: MKMapViewDelegate {
    
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
