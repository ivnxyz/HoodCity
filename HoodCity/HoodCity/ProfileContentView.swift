//
//  ProfileContentView.swift
//  HoodCity
//
//  Created by Iván Martínez on 12/08/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit

class ProfileContentView: UIView {
    
    static let cellHeight: CGFloat = 78
    
    // MARK: - UI elements
    
    lazy var profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.image = User.shared?.profilePicture ?? #imageLiteral(resourceName: "avatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = User.shared?.name
        label.textColor = UIColor(red: 88/255, green: 88/255, blue: 88/255, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Init
    
    init(width: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: ProfileContentView.cellHeight))
        
        addSubview(profilePicture)
        addSubview(nameLabel)
        
        let profilePictureHeight: CGFloat = 54
        
        NSLayoutConstraint.activate([
            self.profilePicture.heightAnchor.constraint(equalToConstant: profilePictureHeight),
            self.profilePicture.widthAnchor.constraint(equalToConstant: profilePictureHeight),
            self.profilePicture.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.profilePicture.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 17)
        ])
        
        self.profilePicture.layer.cornerRadius = profilePictureHeight / 2
        self.profilePicture.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            self.nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.nameLabel.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 16)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
