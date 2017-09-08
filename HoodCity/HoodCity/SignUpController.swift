//
//  SignUpController.swift
//  HoodCity
//
//  Created by Iván Martínez on 25/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import TwitterKit

class SignUpController: UIViewController {
    
    //MARK: - UI Elements
    
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var getStartedButton: UIButton!
    
    lazy var termsAlertController: UIAlertController = {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Read Terms and Conditions", style: .default, handler: self.readTermsAndConditions))
        alertController.addAction(UIAlertAction(title: "Read Privacy Policy", style: .default, handler: self.readPrivacyPolicy))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        return alertController
    }()
    
    lazy var signUpView: SignUpView = {
        let signUpView = SignUpView(frame: self.view.bounds)
        signUpView.delegate = self
        
        return signUpView
    }()
    
    lazy var firebaseClient: FirebaseClient = {
        let client = FirebaseClient()
        
        return client
    }()
    
    //MARK: - ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStartedButton.layer.cornerRadius = 6
        getStartedButton.layer.borderWidth = 2
        getStartedButton.layer.borderColor = UIColor.white.cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    // MARK: - Sign Up
    
    @IBAction func getStarted(_ sender: UIButton) {
        view.addSubview(signUpView)
        signUpView.show()
    }
    
    func showMapController() {
        signUpView.dismiss()
        
        print("Showing MapController...")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapController = storyboard.instantiateInitialViewController()
        present(mapController!, animated: false, completion: nil)
    }
    
    // MARK: - Error Handling
    
    func handle(_ error: Error?) {
        guard let error = error else { return }
        
        signUpView.stopActivityIndicator()
        
        let alertController = UIAlertController(title: "Oops! :(", message: "\(error.localizedDescription)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        print("error: \(error)")
    }
    
    // MARK: - Legal stuff
    
    func readTermsAndConditions(alertAction: UIAlertAction) {
        if let url = URL(string: termsAndConditionsURL) {
            let urlRequest = URLRequest(url: url)
            let pdfController = PDFController(request: urlRequest, title: "Terms and Conditions")
            
            let navigationController = UINavigationController(rootViewController: pdfController)
            
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    func readPrivacyPolicy(alertAction: UIAlertAction) {
        
        if let url = URL(string: privacyPolicyURL) {
            let urlRequest = URLRequest(url: url)
            let pdfController = PDFController(request: urlRequest, title: "Privacy Policy")
            
            let navigationController = UINavigationController(rootViewController: pdfController)
            
            present(navigationController, animated: true, completion: nil)
        }
    }
    
}

extension SignUpController: SignUpViewDelegate {
    
    //MARK: - SignUpViewDelegate
    
    func loginWithFacebook() {
        FBSDKLoginManager().logIn(withReadPermissions:  ["email", "public_profile"], from: self) { (result, error) in
            
            guard error == nil else {
                print("Error at Facebook's log in: ", error!)
                self.handle(error)
                return
            }
            
            self.signUpView.startActivityIndicator()
            
            let accessToken = FBSDKAccessToken.current()
            guard let accessTokenString = accessToken?.tokenString else { return }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
            
            Auth.auth().signIn(with: credential) { (firebaseUser, error) in
                
                guard error == nil else {
                    print("Something went wrong with Facebook user: ", error!)
                    self.handle(error)
                    return
                }
                
                FacebookClient().getUserProfileData(completionHandler: { (error, facebookData) in
                    guard error == nil else {
                        self.handle(error)
                        return
                    }
                    
                    if let facebookData = facebookData {
                        self.firebaseClient.updateCurrentUserProfile(with: facebookData, completionHandler: { (error) in
                            if error != nil {
                                self.handle(error)
                            } else {
                                DispatchQueue.main.async {
                                    self.showMapController()
                                }
                            }
                        })
                    }
                })
            }
        }
    }
    
    func loginWithTwitter() {
        Twitter.sharedInstance().logIn { (session, error) in
            
            self.signUpView.startActivityIndicator()
            
            if let session = session {
                print("signed in as \(session.userName)")
                let authToken = session.authToken
                let authTokenSecret = session.authTokenSecret
                
                let credential = TwitterAuthProvider.credential(withToken: authToken, secret: authTokenSecret)
                
                Auth.auth().signIn(with: credential, completion: { (user, error) in

                    let twitterClient = TwitterClient()
                    
                    twitterClient.getUserProfileData(completionHandler: { (error, twitterData) in
                        guard let twitterData = twitterData, error == nil else {
                            DispatchQueue.main.async {
                                self.handle(error)
                            }
                            return
                        }
                        
                        self.firebaseClient.updateCurrentUserProfile(with: twitterData, completionHandler: { (error) in
                            if error != nil {
                                self.handle(error)
                            } else {
                                DispatchQueue.main.async {
                                    self.showMapController()
                                }
                            }
                        })
                    })
                })
            } else {
                self.handle(error)
            }
        }
    }
    
    func userTappedTermsLabel() {
        self.present(termsAlertController, animated: true, completion: nil)
    }
    
}

