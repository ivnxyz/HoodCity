//
//  EventController.swift
//  HoodCity
//
//  Created by Iván Martínez on 14/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit

class EventController: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.alpha = 0
    }
    
    lazy var logInView: LogInView = {
        let view = LogInView()
        
        return view
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.alpha = 1
            
        }, completion: nil)
        
        showMenu()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EventController.dismissMenu))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    func showMenu() {
        logInView.show()
    }

    func dismissMenu() {
        logInView.dismiss()
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
            self.view.alpha = 0
        }) { (true) in
            self.dismiss(animated: false, completion: nil)
        }
    }
}
