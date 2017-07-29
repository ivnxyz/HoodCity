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
    
    //MARK: ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let navigationBerHeight = self.navigationController?.navigationBar.bounds.height else { return }

        view.backgroundColor = .white
        title = "You"
        
        navigationItem.rightBarButtonItem = cancelButton
        
        view.addSubview(profilePicture)
        
        let profilePictureHeight = view.bounds.height * 0.1604
        
        NSLayoutConstraint.activate([
            profilePicture.heightAnchor.constraint(equalToConstant: profilePictureHeight),
            profilePicture.widthAnchor.constraint(equalToConstant: profilePictureHeight),
            profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profilePicture.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationBerHeight * 2)
        ])
        
        profilePicture.layer.cornerRadius = profilePictureHeight/2
        profilePicture.layer.masksToBounds = true
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }

}
