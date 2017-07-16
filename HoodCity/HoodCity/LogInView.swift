//
//  LogInView.swift
//  HoodCity
//
//  Created by Iván Martínez on 14/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation
import UIKit

class LogInView: UIView {
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
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
        
        window.addSubview(backgroundView)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.backgroundView.frame = CGRect(x: 0, y: backgroundViewHeight, width: backgroundViewWidth, height: backgroundViewHeight)
            
        }, completion: nil)
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.alpha = 0
            
            self.backgroundView.frame = CGRect(x: 0, y: self.backgroundView.frame.height * 2, width: self.backgroundView.frame.width, height: self.backgroundView.frame.height)
        }
        
        self.removeFromSuperview()
    }
}





