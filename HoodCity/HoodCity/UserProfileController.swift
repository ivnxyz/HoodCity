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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "You"
        
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }

}
