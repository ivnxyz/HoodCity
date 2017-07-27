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
}

class SignUpView: UIView {
    
    //MARK: - UI Elements
    
    lazy var backgroundView: UIView = {
        
        let backgroundViewHeight = CGFloat(440)
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
        customFacebookButton.layer.cornerRadius = 8
        
        customFacebookButton.translatesAutoresizingMaskIntoConstraints = false
        
        return customFacebookButton
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 63/255.0, green: 63/255.0, blue: 63/255.0, alpha: 1)
        label.text = "Sign in to add a new event"
        label.font = UIFont.systemFont(ofSize: 21, weight: UIFontWeightSemibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
        
        let backgroundViewHeight = self.frame.height / 2
        let backgroundViewWidth = self.frame.width
        
        // Add subviews
        
        backgroundView.frame = CGRect(x: 0, y: backgroundViewHeight * 3, width: backgroundViewWidth, height: backgroundViewHeight)
        
        addSubview(backgroundView)
        backgroundView.addSubview(loginButton)
        backgroundView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            loginButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, constant: -30),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.alpha = 1
            
            let backgroundViewY = self.frame.height - self.backgroundView.frame.height
            
            self.backgroundView.frame = CGRect(x: 0, y: backgroundViewY, width: self.backgroundView.frame.width, height: self.backgroundView.frame.height)
            
        }, completion: nil)
    }
    
    //MARK: - Dismiss
    
    func dismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.alpha = 0
            
            self.backgroundView.frame = CGRect(x: 0, y: self.backgroundView.frame.height * 2, width: self.backgroundView.frame.width, height: self.backgroundView.frame.height)
            
        }, completion: { (true) in
            self.removeFromSuperview()
        })
    }
    
    func facebookButtonPressed() {
        delegate?.loginWithFacebook()
    }
}

