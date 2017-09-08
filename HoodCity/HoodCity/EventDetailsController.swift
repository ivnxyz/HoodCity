//
//  EventDetailsController.swift
//  HoodCity
//
//  Created by Iván Martínez on 30/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit
import GoogleMobileAds

class EventDetailsController: UIViewController, GADBannerViewDelegate {
    
    var event: Event?
    
    //MARK: - UIElements
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    lazy var bannerView: GADBannerView = {
        let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.rootViewController = self
        bannerView.clipsToBounds = true
        bannerView.adUnitID = eventDetailsBannerViewID
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.delegate = self
        bannerView.adUnitID = eventInfoBannerViewId
        bannerView.load(request)
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        return bannerView
    }()
    
    //MARK: - Dependencies
    
    let firebaseClient = FirebaseClient()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLabel.text = ""
        eventTitleLabel.text = ""
        dateLabel.text = ""
    
        view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        if let event = event {
            // Configure data
            eventTitleLabel.text = event.eventType.cleanTitle
            iconImageView.image = event.eventType.icon
            
            // Configure date
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            
            let dateStringRepresentation = formatter.string(from: event.date)

            dateLabel.text = dateStringRepresentation            
            // Get user profile to configure view
            
            getUserProfile()
        }
        
    }
    
    func getUserProfile() {
        
        guard let event = event else { return }
        
        firebaseClient.getEventData(for: event) { (eventData) in
            
            guard let eventData = eventData else {
                print("Cannot get event data to get user's id")
                return
            }
            
            self.firebaseClient.getProfileFor(userId: eventData.userID) { (firebaseError, firebaseUser) in
                guard let user = firebaseUser else {
                    print("We can't get information about the user that posted this event")
                    return
                }
                
                guard let profilePictureUrl = URL(string: user.profilePictureUrl) else {
                    print("Cannot get profile picture url")
                    return
                }
                
                self.userNameLabel.text = user.name
                
                URLSession.shared.dataTask(with: profilePictureUrl, completionHandler: { (data, response, error) in
                    guard error == nil else {
                        print(error!)
                        return
                    }
                    
                    guard let profilePicture = UIImage(data: data!) else {
                        print("Cannot convert to image")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height/2
                        self.profileImageView.layer.masksToBounds = true
                        self.profileImageView.image = profilePicture
                    }
                }).resume()
            }
        }
        
    }

}
