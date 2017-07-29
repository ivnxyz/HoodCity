//
//  UserProfileController.swift
//  HoodCity
//
//  Created by Iván Martínez on 29/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit

class UserProfileController: UIViewController {
    
    //MARK: UI Elements
    
    lazy var cancelButton:  UIBarButtonItem = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(#imageLiteral(resourceName: "cancel-button"), for: .normal)
        button.addTarget(self, action: #selector(UserProfileController.cancel), for: .touchUpInside)
        
        let tabBarButtonItem = UIBarButtonItem(customView: button)
        
        return tabBarButtonItem
    }()
    
    lazy var profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.image = FacebookUser.shared.profilePicture
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = FacebookUser.shared.name
        label.textColor = UIColor(red: 88/255, green: 88/255, blue: 88/255, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    //MARK: ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let navigationBerHeight = self.navigationController?.navigationBar.bounds.height else { return }

        view.backgroundColor = .white
        title = "You"
        
        navigationItem.rightBarButtonItem = cancelButton
        
        view.addSubview(profilePicture)
        view.addSubview(nameLabel)
        
        let profilePictureHeight = view.bounds.height * 0.1604
        
        NSLayoutConstraint.activate([
            profilePicture.heightAnchor.constraint(equalToConstant: profilePictureHeight),
            profilePicture.widthAnchor.constraint(equalToConstant: profilePictureHeight),
            profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profilePicture.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationBerHeight * 2)
        ])
        
        profilePicture.layer.cornerRadius = profilePictureHeight/2
        profilePicture.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }

}
