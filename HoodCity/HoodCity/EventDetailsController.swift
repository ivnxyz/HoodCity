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
        label.textAlignment = .center
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
         guard let navigationBerHeight = self.navigationController?.navigationBar.bounds.height else { return }

        view.backgroundColor = .white
        title = "Event Details"
        
        view.addSubview(iconView)
        view.addSubview(eventTitleLabel)
        view.addSubview(dotsView)
        
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
        
    }

}






