//
//  SignInController.swift
//  HoodCity
//
//  Created by Iván Martínez on 23/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SignInController: UIViewController {
    
    //MARK: - UI Elements
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.delegate = self
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
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
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            loginButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
        ])
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.backgroundView.frame = CGRect(x: 0, y: backgroundViewHeight, width: backgroundViewWidth, height: backgroundViewHeight)
            
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
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User loged out")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print(result)
    }
}



