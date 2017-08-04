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
    
    let eventTitle = UILabel()
    let dateLabel = UILabel()
    let eventIcon = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        eventIcon.image = #imageLiteral(resourceName: "party")
        eventIcon.translatesAutoresizingMaskIntoConstraints = false
        
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with event: Event) {
        
    }

}
