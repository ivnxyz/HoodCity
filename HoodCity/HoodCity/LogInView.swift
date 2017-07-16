//
//  LogInView.swift
//  HoodCity
//
//  Created by Iván Martínez on 14/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation
import UIKit

class LogInView: UIView, Menu {
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var facebookButton: UIButton = {
        let button = UIButton()
        button.setTitle("Facebook", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(LogInView.signInWithFacebook), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func show() {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        let backgroundViewHeight = window.frame.height / 2
        let backgroundViewWidth = window.frame.width
        
        backgroundView.frame = CGRect(x: 0, y: backgroundViewHeight * 2, width: backgroundViewWidth, height: backgroundViewHeight)
        facebookButton.frame = CGRect(x: backgroundViewWidth / 2 - 50, y: backgroundViewHeight / 2 - 25, width: 100, height: 50)
        
        backgroundView.addSubview(facebookButton)
        window.addSubview(backgroundView)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.backgroundView.frame = CGRect(x: 0, y: backgroundViewHeight, width: backgroundViewWidth, height: backgroundViewHeight)
            
        }, completion: nil)
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.4) {
            self.backgroundView.alpha = 0
            
            self.backgroundView.frame = CGRect(x: 0, y: self.backgroundView.frame.height * 2, width: self.backgroundView.frame.width, height: self.backgroundView.frame.height)
        }
        
        self.removeFromSuperview()
    }
    
    // MARK: - Facebook
    
    func signInWithFacebook() {
        print("Sign in with Facebook")
    }
}





