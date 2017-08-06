//
//  SignUpView.swift
//  HoodCity
//
//  Created by Iván Martínez on 26/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit

protocol SignUpViewDelegate: class {
    func loginWithFacebook()
    func loginWithTwitter()
}

class SignUpView: UIView {
    
    //MARK: - UI Elements
    
    lazy var backgroundView: UIView = {
        
        let backgroundViewHeight = CGFloat(250)
        let backgroundViewWidth = self.frame.width
        
        let view = UIView(frame: CGRect(x: 0, y: backgroundViewHeight * 2, width: backgroundViewWidth, height: backgroundViewHeight))
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var loginButton: UIButton = {
        let customFacebookButton = UIButton(type: .system)
        customFacebookButton.backgroundColor = UIColor(red: 59/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1)
        customFacebookButton.setTitle("Facebook", for: .normal)
        customFacebookButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        customFacebookButton.setTitleColor(.white, for: .normal)
        customFacebookButton.addTarget(self, action: #selector(SignUpView.facebookButtonPressed), for: .touchUpInside)
        customFacebookButton.layer.cornerRadius = 9
        
        customFacebookButton.translatesAutoresizingMaskIntoConstraints = false
        
        return customFacebookButton
    }()
    
    lazy var twitterLoginButton: UIButton = {
        let twitterButton = UIButton(type: .system)
        twitterButton.backgroundColor = UIColor(red: 0/255.0, green: 172/255.0, blue: 237/255.0, alpha: 1)
        twitterButton.setTitle("Twitter", for: .normal)
        twitterButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        twitterButton.setTitleColor(.white, for: .normal)
        twitterButton.addTarget(self, action: #selector(SignUpView.twitterButtonPressed), for: .touchUpInside)
        twitterButton.layer.cornerRadius = 9
        
        twitterButton.translatesAutoresizingMaskIntoConstraints = false
        
        return twitterButton
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 63/255.0, green: 63/255.0, blue: 63/255.0, alpha: 1)
        label.text = "Sign In or Sign Up"
        label.font = UIFont.systemFont(ofSize: 21, weight: UIFontWeightSemibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    //MARK: - Dependencies
    
    lazy var loadingView: LoadingView = {
        return LoadingView()
    }()
    
    weak var delegate: SignUpViewDelegate?
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Show
    
    func show() {
        
        // Add gesture recognizer
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpView.dismiss))
        self.addGestureRecognizer(gestureRecognizer)
        
        // Add subviews
        addSubview(backgroundView)
        backgroundView.addSubview(loginButton)
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(twitterLoginButton)
        
        activateConstraints()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.alpha = 1
            
            let backgroundViewY = self.frame.height - self.backgroundView.frame.height
            
            self.backgroundView.frame = CGRect(x: 0, y: backgroundViewY, width: self.backgroundView.frame.width, height: self.backgroundView.frame.height)
            
        }, completion: nil)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            loginButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, constant: -30),
            loginButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        NSLayoutConstraint.activate([
            twitterLoginButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 32),
            twitterLoginButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            twitterLoginButton.heightAnchor.constraint(equalTo: loginButton.heightAnchor),
            twitterLoginButton.widthAnchor.constraint(equalTo: loginButton.widthAnchor)
        ])
    }
    
    //MARK: - Dismiss
    
    func dismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.alpha = 0
            
            self.backgroundView.frame = CGRect(x: 0, y: self.backgroundView.frame.height * 2, width: self.backgroundView.frame.width, height: self.backgroundView.frame.height)
            
            self.loadingView.stop()
            
        }, completion: { (true) in
            self.removeFromSuperview()
        })
    }
    
    //MARK: - ActivityIndicator
    
    func startActivityIndicator() {
        for view in backgroundView.subviews {
            view.removeFromSuperview()
        }
        
        backgroundView.addSubview(loadingView)
        loadingView.start()
        
        NSLayoutConstraint.activate([
            loadingView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 80),
            loadingView.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func stopActivityIndicator() {
        loadingView.stop()
        
        backgroundView.addSubview(loginButton)
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(twitterLoginButton)
        
        activateConstraints()
    }
    
    //MARK: - Delegate
    
    func facebookButtonPressed() {
        delegate?.loginWithFacebook()
    }
    
    func twitterButtonPressed() {
        delegate?.loginWithTwitter()
    }
}

