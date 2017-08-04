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
    
    lazy var eventTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 88/255, green: 88/255, blue: 88/255, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 88/255, green: 88/255, blue: 88/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var eventIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(eventTitle)
        addSubview(dateLabel)
        addSubview(eventIcon)
        
        print("NEW CELL")
        
        NSLayoutConstraint.activate([
            eventIcon.heightAnchor.constraint(equalToConstant: 30),
            eventIcon.widthAnchor.constraint(equalToConstant: 30),
            eventIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 26),
            eventIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            eventTitle.leadingAnchor.constraint(equalTo: eventIcon.trailingAnchor, constant: 26),
            eventTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 17)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: eventIcon.trailingAnchor, constant: 26),
            dateLabel.topAnchor.constraint(equalTo: eventTitle.bottomAnchor, constant: 9)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with event: Event) {
        eventTitle.text = event.eventType.cleanTitle
        eventIcon.image = event.eventType.icon
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/M/yyyy, H:mm"
        let dateStringRepresentation = formatter.string(from: event.date)
        
        dateLabel.text = "Added: \(dateStringRepresentation)"
    }

}
