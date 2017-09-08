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
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var eventsCell: UITableViewCell!
    @IBOutlet weak var privacyPolicyCell: UITableViewCell!
    @IBOutlet weak var termsAndConditionsCell: UITableViewCell!
    
    lazy var signoutAlert: UIAlertController = {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: self.signOut(alertAction:)))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        return alertController
    }()
    
    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsCell.textLabel?.text = "My Active Events 🎉"
        privacyPolicyCell.textLabel?.text = "Read Privacy Policy"
        termsAndConditionsCell.textLabel?.text = "Read Terms and Conditions"

        profileImageView.image = User.shared?.profilePicture ?? #imageLiteral(resourceName: "avatar")
        userNameLabel.text = User.shared?.name ?? ""
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                readPrivacyPolicy()
            } else if indexPath.row == 1 {
                readTermsAndConditions()
            }
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
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - SignOut
    
    @IBAction func userPressedSignoutButton(_ sender: UIButton) {
        self.present(signoutAlert, animated: true, completion: nil)
    }
    
    func signOut(alertAction: UIAlertAction) {
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
            let signUpController = storyboard.instantiateInitialViewController()!
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
