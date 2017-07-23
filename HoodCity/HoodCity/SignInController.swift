//
//  SignInController.swift
//  HoodCity
//
//  Created by Iván Martínez on 23/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

protocol SignInControllerDelegate: class {
    func userDidSignIn()
}

class SignInController: UIViewController {
    
    //MARK: - UI Elements
    
    lazy var backgroundView: UIView = {
        guard let window = UIApplication.shared.keyWindow else { return UIView() }
        
        let backgroundViewHeight = CGFloat(440)
        let backgroundViewWidth = window.frame.width
        
        let view = UIView(frame: CGRect(x: 0, y: backgroundViewHeight * 2, width: backgroundViewWidth, height: backgroundViewHeight))
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.delegate = self
        button.readPermissions = ["email"]
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 63/255.0, green: 63/255.0, blue: 63/255.0, alpha: 1)
        label.text = "Sign in to add a new event"
        label.font = UIFont.systemFont(ofSize: 21, weight: UIFontWeightSemibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    //MARK: - Init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.alpha = 0
    }
    
    weak var delegate: SignInControllerDelegate?
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInController.handleDismiss))
        view.addGestureRecognizer(gestureRecognizer)
        
        let backgroundViewHeight = window.frame.height / 2
        let backgroundViewWidth = window.frame.width
        
        backgroundView.frame = CGRect(x: 0, y: backgroundViewHeight * 3, width: backgroundViewWidth, height: backgroundViewHeight)
        
        window.addSubview(backgroundView)
        backgroundView.addSubview(loginButton)
        backgroundView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            loginButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 30),
            loginButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -30)
        ])
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            let backgroundViewY = window.frame.height - self.backgroundView.frame.height
            self.backgroundView.frame = CGRect(x: 0, y: backgroundViewY, width: self.backgroundView.frame.width, height: self.backgroundView.frame.height)
            
        }, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.alpha = 1
            
        }, completion: nil)
    }
    
    //MARK: - Dismiss
    
    func handleDismiss() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.alpha = 0
            
            self.backgroundView.frame = CGRect(x: 0, y: self.backgroundView.frame.height * 2, width: self.backgroundView.frame.width, height: self.backgroundView.frame.height)
            
        }) { (true) in
            self.dismiss(animated: false, completion: nil)
        }
    }
}

extension SignInController: FBSDKLoginButtonDelegate {
    
    //MARK: - FBSDKLogInButtonDelegate
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User loged out")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signIn(with: credentials) { (user, error) in
            if error != nil {
                print("Something went wrong with Facebook user: ", error!)
                return
            }
            
            self.delegate?.userDidSignIn()
            self.handleDismiss()
            print("Logged in with our user:", user!)
        }
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            if error != nil {
                print("Failed to start graph request:", err!)
                return
            }
            
            print(result!)
        }
    }
}



