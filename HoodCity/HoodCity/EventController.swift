//
//  EventController.swift
//  HoodCity
//
//  Created by Iván Martínez on 14/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit

protocol Menu {
    func show()
    func dismiss()
}

class EventController: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.alpha = 0
    }
    
    lazy var logInView: LogInView = {
        let view = LogInView()
        
        return view
    }()
    
    lazy var eventInfoView: EventInfoView = {
        let eventInfo = EventInfoView()
        eventInfo.delegate = self
        
        return eventInfo
    }()
    
    let geoFireClient = GeoFireClient()
    let firebaseClient = FirebaseClient()
    let locationManager = LocationManager(mapView: nil)
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.alpha = 1
            
        }, completion: nil)
        
        showMenu(menu: eventInfoView)
    }
    
    // MARK: - Add events to Firebase
    
    func create(_ event: Event, at location: CLLocation, with eventId: String) {
        geoFireClient.createSighting(for: location, with: eventId)
        firebaseClient.addDateToExistingEvent(eventId)
        firebaseClient.addEventType(event, to: eventId)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EventController.handleDismiss))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: - Handle Menu
    
    func showMenu(menu: Menu) {
        menu.show()
    }
    
    func handleDismiss() {
        dismissMenu(menu: eventInfoView)
    }

    func dismissMenu(menu: Menu) {
        menu.dismiss()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.alpha = 0
        }) { (true) in
            self.dismiss(animated: false, completion: nil)
        }
    }
}

extension EventController: EventInfoDelegate {
    
    //MARK: - EventInfoDelegate
    
    func eventSelected(event: Event) {

        guard let location = locationManager.currentLocation() else { return }
        let timeStampId = "\(Int(NSDate.timeIntervalSinceReferenceDate * 100000))"
        
        create(event, at: location, with: timeStampId)
        
        handleDismiss()
    }
}








