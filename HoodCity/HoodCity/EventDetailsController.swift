//
//  EventDetailsController.swift
//  HoodCity
//
//  Created by Iván Martínez on 30/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit

class EventDetailsController: UIViewController {
    
    var event: Event?
    
    //MARK: - UIElements
    
    lazy var eventTitleLabel: UILabel = {
        guard let event = self.event else { return UILabel() }
        
        let label = UILabel()
        label.text = event.eventType.cleanTitle
        label.textColor = UIColor(red: 88/255, green: 88/255, blue: 88/255, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var iconView: UIImageView = {
        guard let event = self.event else { return UIImageView() }
        
        let imageView = UIImageView()
        imageView.image = event.eventType.icon
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var dotsView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "dots")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(red: 88/255, green: 88/255, blue: 88/255, alpha: 1)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        guard let event = self.event else { return UILabel() }
        
        let label = UILabel()
        
        // Get string representation
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        let dateStringRepresentation = formatter.string(from: event.date)
        
        label.text = "Added: \(dateStringRepresentation)"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(red: 88/255, green: 88/255, blue: 88/255, alpha: 1)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var userProfilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "avatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    //MARK: - Dependencies
    
    let firebaseClient = FirebaseClient()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let navigationBerHeight = self.navigationController?.navigationBar.bounds.height else { return }

        view.backgroundColor = .white
        title = "Event Details"
        
        view.addSubview(iconView)
        view.addSubview(eventTitleLabel)
        view.addSubview(dotsView)
        view.addSubview(dateLabel)
        view.addSubview(userProfilePicture)
        view.addSubview(userNameLabel)
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationBerHeight * 2),
            iconView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 51),
            iconView.widthAnchor.constraint(equalToConstant: 51)
        ])
        
        NSLayoutConstraint.activate([
            eventTitleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 30),
            eventTitleLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dotsView.widthAnchor.constraint(equalToConstant: 14),
            dotsView.heightAnchor.constraint(equalToConstant: 110),
            dotsView.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 13),
            dotsView.centerXAnchor.constraint(equalTo: iconView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: eventTitleLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            userProfilePicture.heightAnchor.constraint(equalToConstant: 51),
            userProfilePicture.widthAnchor.constraint(equalToConstant: 51),
            userProfilePicture.topAnchor.constraint(equalTo: dotsView.bottomAnchor, constant: 13),
            userProfilePicture.centerXAnchor.constraint(equalTo: dotsView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userNameLabel.centerYAnchor.constraint(equalTo: userProfilePicture.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: userProfilePicture.trailingAnchor, constant: 30)
        ])
        
        // Get user profile to configure view
        
        getUserProfile()
    }
    
    func getUserProfile() {
        
        guard let event = event else { return }
        
        firebaseClient.getProfileFor(userId: event.userId) { (firebaseUser) in
            guard let user = firebaseUser else {
                print("Cannot get user from database")
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
                    self.userProfilePicture.layer.cornerRadius = self.userProfilePicture.frame.height/2
                    self.userProfilePicture.layer.masksToBounds = true
                    self.userProfilePicture.image = profilePicture
                }
            }).resume()
        }
    }

}






