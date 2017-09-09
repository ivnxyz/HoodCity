//
//  EventCell.swift
//  HoodCity
//
//  Created by Iván Martínez on 03/08/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    static let reuseIdentifier = "EventCell"
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventIconView: UIImageView!
    
    func configure(with event: Event) {
        eventTitleLabel.text = event.eventType.cleanTitle
        eventIconView.image = event.eventType.icon
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateStringRepresentation = formatter.string(from: event.date)
        
        let added = NSLocalizedString("Date.Added", comment: "")
        
        dateLabel.text = "\(added): \(dateStringRepresentation)"
    }

}
