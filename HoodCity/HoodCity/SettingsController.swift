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
        let alertController = UIAlertController(title: nil, message: NSLocalizedString("SettingsController.SignoutAlert.Message", comment: ""), preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("SettingsController.SignoutAlert.SignOut", comment: ""), style: .destructive, handler: self.signOut(alertAction:)))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("SettingsController.SignoutAlert.Cancel", comment: ""), style: .cancel, handler: nil))
        
        return alertController
    }()
    
    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsCell.textLabel?.text = NSLocalizedString("SettingsController.MyEvents", comment: "")
        privacyPolicyCell.textLabel?.text = NSLocalizedString("Legal.PrivacyPolicy", comment: "")
        termsAndConditionsCell.textLabel?.text = NSLocalizedString("Legal.TermsAndConditions", comment: "")

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
            let pdfController = PDFController(request: urlRequest, title: NSLocalizedString("Legal.TermsAndConditions", comment: ""))
            
            navigationController?.pushViewController(pdfController, animated: true)
        }
    }
    
    func readPrivacyPolicy() {
        if let url = URL(string: privacyPolicyURL) {
            let urlRequest = URLRequest(url: url)
            let pdfController = PDFController(request: urlRequest, title: NSLocalizedString("Legal.PrivacyPolicy", comment: ""))
            
            navigationController?.pushViewController(pdfController, animated: true)
        }
    }

}
