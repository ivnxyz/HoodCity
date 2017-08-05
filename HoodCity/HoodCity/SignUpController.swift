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
    
    lazy var backgroundImage: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: self.view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "background_image")
        
        return imageView
    }()
    
    lazy var mapImage: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "map_image")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Discover events around you. \n Create new events."
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get started", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
    
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(SignUpController.showSignUpView), for: .touchUpInside)
        
        return button
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

        view.addSubview(backgroundImage)
        view.addSubview(mapImage)
        view.addSubview(titleLabel)
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            mapImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            mapImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapImage.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.35),
            mapImage.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.35)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: mapImage.bottomAnchor, constant: view.bounds.height * 0.06),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            startButton.heightAnchor.constraint(equalToConstant: 38),
            startButton.widthAnchor.constraint(equalToConstant: 134),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.bounds.height * -0.08),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    //MARK: - Sign Up
    
    func showSignUpView() {
        view.addSubview(signUpView)
        signUpView.show()
    }
    
    func showMapController() {
        signUpView.dismiss()
        
        print("UI updated")
        let mapController = MapController()
        let navigationController = UINavigationController(rootViewController: mapController)
        present(navigationController, animated: false, completion: nil)
    }
    
    func handle(_ error: Error?) {
        guard let error = error else { return }
        
        signUpView.stopActivityIndicator()
        print("error: \(error)")
    }
    
}

extension SignUpController: SignUpViewDelegate {
    
    //MARK: - SignUpViewDelegate
    
    func loginWithFacebook() {
        FBSDKLoginManager().logIn(withReadPermissions:  ["email", "public_profile"], from: self) { (result, error) in
            
            guard error == nil else {
                print("Error at Facebook's log in: ", error!)
                
                return
            }
            
            self.signUpView.startActivityIndicator()
            
            let accessToken = FBSDKAccessToken.current()
            guard let accessTokenString = accessToken?.tokenString else { return }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
            
            Auth.auth().signIn(with: credential) { (firebaseUser, error) in
                
                guard error == nil else {
                    print("Something went wrong with Facebook user: ", error!)
                    self.signUpView.stopActivityIndicator()
                    return
                }
                
                FacebookClient().getUserData(completionHandler: { (user) in
                    
                    self.firebaseClient.updateUserProfile(with: user, completionHandler: { (error) in
                        if error != nil {
                            self.handle(error)
                        } else {
                            DispatchQueue.main.async {
                                self.showMapController()
                            }
                        }
                    })
                })
            }
        }
    }
    
    func loginWithTwitter() {
        signUpView.startActivityIndicator()
        
        Twitter.sharedInstance().logIn { (session, error) in
            if let session = session {
                print("signed in as \(session.userName)")
                let authToken = session.authToken
                let authTokenSecret = session.authTokenSecret
                
                let credential = TwitterAuthProvider.credential(withToken: authToken, secret: authTokenSecret)
                
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    
                    guard let firebaseUser = user else {
                        self.handle(error)
                        return
                    }
                    
                    let twitterClient = TwitterClient()
                    
                    twitterClient.getUserData(completionHandler: { (user, error) in
                        
                        guard let user = user else {
                            DispatchQueue.main.async {
                                self.handle(error)
                            }
                            return
                        }
                        
                        twitterClient.getUserEmail(completionHandler: { (email, error) in
                            if let email = email {
                                
                                firebaseUser.updateEmail(to: email, completion: { (error) in
                                    if error != nil {
                                        self.handle(error)
                                    } else {
                                        user.email = email
                                    }
                                    
                                    self.firebaseClient.updateUserProfile(with: user, completionHandler: { (error) in
                                        if error != nil {
                                            self.handle(error)
                                        } else {
                                            DispatchQueue.main.async {
                                                self.showMapController()
                                            }
                                        }
                                    })
                                })
                            } else {
                                
                                self.firebaseClient.updateUserProfile(with: user, completionHandler: { (error) in
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
                    })
                })
            }
        }
    }
    
}

