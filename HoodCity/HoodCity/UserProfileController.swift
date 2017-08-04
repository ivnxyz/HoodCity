//
//  UserProfileController.swift
//  HoodCity
//
//  Created by Iván Martínez on 03/08/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UITableViewController {
    
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
        imageView.image = User.shared?.profilePicture
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
    
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        
        view.addSubview(self.profilePicture)
        view.addSubview(self.nameLabel)
        
        let profilePictureHeight = self.view.bounds.height * 0.1604
        
        NSLayoutConstraint.activate([
            self.profilePicture.heightAnchor.constraint(equalToConstant: profilePictureHeight),
            self.profilePicture.widthAnchor.constraint(equalToConstant: profilePictureHeight),
            self.profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.profilePicture.topAnchor.constraint(equalTo: view.topAnchor, constant: 48)
        ])
        
        self.profilePicture.layer.cornerRadius = profilePictureHeight/2
        self.profilePicture.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: self.profilePicture.bottomAnchor, constant: 10),
            self.nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        return view
    }()
    
    lazy var signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(UserProfileController.signOut), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        view.addSubview(self.signOutButton)
        
        NSLayoutConstraint.activate([
            self.signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.signOutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
        ])
        
        return view
    }()
    
    lazy var placeholderView: UIView = {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        let titleLabel = UILabel()
        
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.text = "You have no events :("
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor(red: 88/255, green: 88/255, blue: 88/255, alpha: 1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        return container
    }()
    
    //MARK: - Dependencies
    
    let firebaseClient = FirebaseClient()
    
    lazy var dataSource: UserProfileDataSource = {
        return UserProfileDataSource(tableView: self.tableView)
    }()
    
    //MARK: - ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "You"
        navigationItem.rightBarButtonItem = cancelButton
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        tableView.separatorInset.left = 0
        
        tableView.register(EventCell.classForCoder(), forCellReuseIdentifier: EventCell.reuseIdentifier)
        tableView.dataSource = dataSource
        tableView.backgroundView?.backgroundColor = .green
        
        getEventsForCurrentUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Delegate 
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    //MARK: - Cancel
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - SignOut
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            let signUpController = SignUpController()
            present(signUpController, animated: false, completion: nil)
        } catch let error {
            print("Error trying to sign out: ", error)
            //Add an alert view
        }
    }
    
    //MARK: - Events
    
    func getEventsForCurrentUser() {
        guard let user = Auth.auth().currentUser else { return }
        
        firebaseClient.getEventsFor(user.uid) { (event) in
            guard let event = event else {
                self.addPlaceholderView()
                return
            }
            
            self.dataSource.update(with: event)
        }
    }
    
    func addPlaceholderView() {
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height + 200)
        tableView.backgroundView = placeholderView
        tableView.isScrollEnabled = false
    }
    
}
