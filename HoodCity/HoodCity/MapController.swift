//
//  MapController.swift
//  HoodCity
//
//  Created by Iván Martínez on 26/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class MapController: UIViewController {
    
    //MARK: - UI Elements
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addEventButton: UIButton!
    
    lazy var userProfileButton: UIBarButtonItem = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(#imageLiteral(resourceName: "avatar"), for: .normal)
        button.addTarget(self, action: #selector(MapController.showUserProfile), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.layer.frame.height / 2
        
        let barButtonItem = UIBarButtonItem(customView: button)
        
        return barButtonItem
    }()
    
    lazy var locationAlertController: UIAlertController = {
        let alert = UIAlertController(title: "Oops! :(", message: "We don't have access to your location.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        return alert
    }()
    
    //MARK: - Dependencies
    
    lazy var locationManager: LocationManager = {
        let manager = LocationManager(mapView: self.mapView)
        manager.delegate = self
        
        return manager
    }()
    
    lazy var geoFireClient: GeoFireClient = {
        return GeoFireClient()
    }()
    
    lazy var firebaseClient: FirebaseClient = {
        return FirebaseClient()
    }()
    
    var mapHasCenteredOnce = false
    
    var annotations = [String: EventAnnotation]()
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = userProfileButton
        
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        
        let navigationButton = navigationItem.rightBarButtonItem?.customView as! UIButton
        
        if let profilePicture = User.shared?.profilePicture {
            navigationButton.setImage(profilePicture, for: .normal)
        } else {
            print("The User object does not exist... we're going to download it")
            
            getCurrentUserData(completionHandler: { (error) in
                
                guard error == nil else {
                    self.handle(error)
                    return
                }
                
                guard let profilePicture = User.shared?.profilePicture else { return }
                
                DispatchQueue.main.async {
                    navigationButton.setImage(profilePicture, for: .normal)
                }
            })
        }
        
        locationManager.requestAuthorization()
    }
    
    //Add new event
    
    @IBAction func addNewEvent(_ sender: UIButton) {
        let controller = EventController()
        controller.modalPresentationStyle = .overCurrentContext
        
        present(controller, animated: false, completion: nil)
    }
    
    //MARK: - Events
    
    func showEvents(at location: CLLocation) {
        geoFireClient.showEvents(at: location) { (geoFireData, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            let eventId = geoFireData!.0
            
            self.isEventExpired(eventId)
        }
    }
    
    func remove(_ event: Event) {
        
        firebaseClient.getEventData(for: event) { (eventData) in
            if let eventData = eventData {
                
                event.eventData = eventData

                self.geoFireClient.remove(event, completionHandler: { (error) in
                    guard error == nil else {
                        print(error!)
                        return
                    }
                })
                
            } else {
                print("Cannot get event data so the event cannot be deleted")
            }
        }
        
    }
    
    func isEventExpired(_ eventId: String) {
        firebaseClient.getEvent(for: eventId) { (event) in
            if let event = event {
                let currentDate = Date()
                let interval = currentDate.timeIntervalSince(event.date)
                
                let hoursSinceEvent = interval / 3600
                
                if hoursSinceEvent > 12.0 {
                    print("Removing event...")
                    self.remove(event)
                } else {
                    let annotation = EventAnnotation(coordinate: event.location.coordinate, event: event)
                    self.annotations[eventId] = annotation
                    
                    self.mapView.addAnnotation(annotation)
                }
            } else {
                print("Cannot get information about event")
            }
        }
    }
    
    func observeExitedKeys(at location: CLLocation) {
        geoFireClient.observeExitedKeys(at: location) { (key, error) in
            if let key = key {
                guard let eventAnnotation = self.annotations[key] else {
                    print("Annotation does not exist")
                    return
                }
                
                print("This is being called on \(key)")
                self.mapView.removeAnnotation(eventAnnotation)
            } else {
                print("Error trying to get data: \(error!)")
            }
        }
    }
    
    
    // MARK: - User
    
    func showUserProfile() {
        performSegue(withIdentifier: "ShowProfile", sender: nil)
    }
    
    func getCurrentUserData(completionHandler: @escaping(Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        firebaseClient.getProfileFor(userId: currentUser.uid) { (firebaseError, firebaseUser) in
            if let firebaseUser = firebaseUser {
                guard let imageUrl = URL(string: firebaseUser.profilePictureUrl) else { return }
                
                URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
                    guard error == nil else {
                        completionHandler(error)
                        return
                    }
                    
                    guard let profilePicutre = UIImage(data: data!) else { return }
                    
                    User.shared?.profilePicture = profilePicutre
                    User.shared?.name = firebaseUser.name
                    
                    completionHandler(nil)
                }).resume()
            } else {
                completionHandler(firebaseError)
            }
        }
    }
    
    // MARK: - Error
    
    func handle(_ error: Error?) {
        guard let error = error else { return }
        
        let alertController = UIAlertController(title: "Oops! :(", message: "\(error.localizedDescription)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        print("Error: \(error)")
    }
    
    // MARK: - Location
    
    func observeEvents() {
        if let location = locationManager.currentLocation() {
            print("Showing events...")
            locationManager.centerMapOnLocation(location)
            mapHasCenteredOnce = true
            mapView.showsUserLocation = true
            showEvents(at: location)
            observeExitedKeys(at: location)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEventDetails" {
            if let destination = segue.destination as? EventDetailsController {
                if let event = sender as? Event {
                    destination.event = event
                }
            }
        }
    }
    
}

extension MapController: LocationManagerDelegate {
    
    // MARK: - LocationManagerDelegate
    
    func locationManagerDidChangeAuthorization(status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            observeEvents()
            print("User allowed when in use acces to location")
        } else if status == .denied {
            print("We don't have access to location")
            present(locationAlertController, animated: true, completion: nil)
        }
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
        let identifier = eventAnnotation.event.eventType.type
        
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? EventAnnotationView {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        } else {
            annotationView = EventAnnotationView(eventAnnotation: eventAnnotation, reuseIdentifier: identifier)
            let calloutAccessoryButton = UIButton(type: .detailDisclosure)
            calloutAccessoryButton.tintColor = UIColor(red: 38/255.0, green: 42/255.0, blue: 152/255.0, alpha: 1)
            
            annotationView?.rightCalloutAccessoryView = calloutAccessoryButton
        }
        
        annotationView?.frame.size = CGSize(width: 30.0, height: 30.0)
        
        print("Creating AnnotationView")
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotationView = view as? EventAnnotationView else { return }
        guard let eventAnnotation = annotationView.annotation as? EventAnnotation  else { return }
        
        let event = eventAnnotation.event
        
        //Add the event as a sender
        performSegue(withIdentifier: "ShowEventDetails", sender: event)
    }
    
}

