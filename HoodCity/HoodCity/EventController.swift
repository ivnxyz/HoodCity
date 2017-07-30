//
//  EventController.swift
//  HoodCity
//
//  Created by Iván Martínez on 22/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit
import GoogleMobileAds

class EventController: UIViewController, GADBannerViewDelegate {
    
    //MARK: - UI elements
    
    lazy var backgroundView: UIView = {
        guard let window = UIApplication.shared.keyWindow else { return UIView() }
        
        let backgroundViewHeight = CGFloat(440)
        let backgroundViewWidth = window.frame.width
        
        let view = UIView(frame: CGRect(x: 0, y: backgroundViewHeight * 2, width: backgroundViewWidth, height: backgroundViewHeight))
        
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var eventPicker: UIPickerView = {
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        return pickerView
    }()
    
    lazy var addEventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add event", for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(21)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(EventController.addEvent), for: .touchUpInside)
        
        return button
    }()
    
    lazy var addEventLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 63/255.0, green: 63/255.0, blue: 63/255.0, alpha: 1)
        label.text = "Add a new event"
        label.font = UIFont.systemFont(ofSize: 21, weight: UIFontWeightSemibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var eventInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 129/255.0, green: 129/255.0, blue: 129/255.0, alpha: 1)
        label.text = "This event will disappear in 12 hours."
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var bannerView: GADBannerView = {
        let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.rootViewController = self
        bannerView.clipsToBounds = true
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.delegate = self
        bannerView.adUnitID = eventInfoBannerViewId
        bannerView.load(request)
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        return bannerView
    }()
    
    //MARK: - Dependencies
    
    let geoFireClient = GeoFireClient()
    let firebaseClient = FirebaseClient()
    let locationManager = LocationManager(mapView: nil)
    
    //MARK: - Init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.alpha = 0
    }
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {

        guard let window = UIApplication.shared.keyWindow else { return }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EventController.handleDismiss))
        view.addGestureRecognizer(gestureRecognizer)
        
        window.addSubview(backgroundView)
        backgroundView.addSubview(addEventLabel)
        backgroundView.addSubview(eventPicker)
        backgroundView.addSubview(addEventButton)
        backgroundView.addSubview(eventInfoLabel)
        backgroundView.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            addEventLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            addEventLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bannerView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            bannerView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            eventInfoLabel.bottomAnchor.constraint(equalTo: bannerView.topAnchor, constant: -69),
            eventInfoLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addEventButton.bottomAnchor.constraint(equalTo: eventInfoLabel.topAnchor, constant: 7),
            addEventButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            addEventButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            addEventButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            eventPicker.topAnchor.constraint(equalTo: addEventLabel.bottomAnchor, constant: 25),
            eventPicker.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            eventPicker.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            eventPicker.bottomAnchor.constraint(equalTo: addEventButton.topAnchor, constant: -25)
        ])
        
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            let backgroundViewY = window.frame.height - self.backgroundView.frame.height
            
            self.backgroundView.frame = CGRect(x: 0, y: backgroundViewY, width: self.backgroundView.frame.width, height: self.backgroundView.frame.height)
            
        }, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.alpha = 1
            
        }, completion: nil)
    }
    
    //MARK: - Dismiss
    
    func handleDismiss() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.alpha = 0
            
            self.backgroundView.frame = CGRect(x: 0, y: self.backgroundView.frame.height * 2, width: self.backgroundView.frame.width, height: self.backgroundView.frame.height)
            
        }) { (true) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    //MARK: - Event
    
    func addEvent() {
        let selectedEventIndex = eventPicker.selectedRow(inComponent: 0)
        guard let event = EventType(index: selectedEventIndex) else { return }
        
        guard let location = locationManager.currentLocation() else { return }
        let childNameId = "\(Int(NSDate.timeIntervalSinceReferenceDate * 100000))"
        
        create(event, at: location, with: childNameId)
    }
    
    func create(_ event: EventType, at location: CLLocation, with eventId: String) {
        geoFireClient.createSighting(for: location, with: eventId)
        firebaseClient.addDateToExistingEvent(eventId)
        firebaseClient.addEventType(event, to: eventId)
        
        handleDismiss()
    }
    
}

extension EventController: UIPickerViewDelegate {
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let event = EventType(index: row)
        return event!.title
    }
    
}

extension EventController: UIPickerViewDataSource {
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return EventType.count
    }
    
}


