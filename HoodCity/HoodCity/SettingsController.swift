//
//  SettingsController.swift
//  HoodCity
//
//  Created by Iván Martínez on 12/08/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit
import Firebase

class SettingsController: UITableViewController {
    
    // MARK: - UI elements
    
    lazy var cancelButton:  UIBarButtonItem = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(#imageLiteral(resourceName: "cancel-button"), for: .normal)
        button.addTarget(self, action: #selector(SettingsController.cancel), for: .touchUpInside)
        
        let tabBarButtonItem = UIBarButtonItem(customView: button)
        
        return tabBarButtonItem
    }()
    
    lazy var signoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Out 😡", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(SettingsController.userPressedSignoutButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var signoutAlert: UIAlertController = {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: self.signOut(alertAction:)))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        return alertController
    }()
    
    // Cells
    
    lazy var profileCell: UITableViewCell = {
        let profileView = ProfileContentView(width: self.view.frame.width)
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 78))
        cell.isUserInteractionEnabled = false
        
        cell.addSubview(profileView)
        
        return cell
    }()
    
    lazy var signoutCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        
        cell.addSubview(self.signoutButton)
        
        NSLayoutConstraint.activate([
            self.signoutButton.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
            self.signoutButton.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])
        
        return cell
    }()
    
    lazy var eventsCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.text = "My active events 🎉"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }()
    
    lazy var privacyPolicyCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Read Privacy Policy"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }()
    
    lazy var termsAndConditionsCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Read Terms and Conditions"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }()
    
    var cells: [[UITableViewCell]]!
    
    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        navigationItem.rightBarButtonItem = cancelButton
        cells = [[profileCell],[eventsCell],[privacyPolicyCell, termsAndConditionsCell],[signoutCell]]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.section][indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return "Profile"
        case 1: return "Events"
        case 2: return "Legal stuff"
        case 3: return "Sign out"
        default: fatalError("Unknown section")
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return ProfileContentView.cellHeight
        default:
            return privacyPolicyCell.frame.height
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            showEventsController()
        case 2:
            switch indexPath.row {
            case 0:
                showPrivacyPolicy()
            case 1:
                showTermsAndConditions()
            default:
                break
            }
        default:
            break
        }
    }
    
    //MARK: - Navigation
    
    func showEventsController() {
        let eventsController = EventsController()
        navigationController?.pushViewController(eventsController, animated: true)
    }
    
    func showPrivacyPolicy() {
        readPrivacyPolicy()
    }
    
    func showTermsAndConditions() {
        readTermsAndConditions()
    }
    
    //MARK: - Cancel
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - SignOut
    
    func userPressedSignoutButton() {
        self.present(signoutAlert, animated: true, completion: nil)
    }
    
    func signOut(alertAction: UIAlertAction) {
        do {
            try Auth.auth().signOut()
            let signUpController = SignUpController()
            present(signUpController, animated: false, completion: nil)
        } catch let error {
            print("Error trying to sign out: ", error)
            //Add an alert view
        }
    }
    
    //MARK: - Legal stuff
    
    func readTermsAndConditions() {
        if let url = URL(string: termsAndConditionsURL) {
            let urlRequest = URLRequest(url: url)
            let pdfController = PDFController(request: urlRequest, title: "Terms and Conditions")
            
            navigationController?.pushViewController(pdfController, animated: true)
        }
    }
    
    func readPrivacyPolicy() {
        if let url = URL(string: privacyPolicyURL) {
            let urlRequest = URLRequest(url: url)
            let pdfController = PDFController(request: urlRequest, title: "Privacy Policy")
            
            navigationController?.pushViewController(pdfController, animated: true)
        }
    }

}
