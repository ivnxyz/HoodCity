//
//  EventController.swift
//  HoodCity
//
//  Created by Iván Martínez on 14/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit

protocol Menu {
    func show()
    func dismiss()
}

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
    
    lazy var eventInfoView: EventInfoView = {
        let eventInfo = EventInfoView()
        eventInfo.delegate = self
        
        return eventInfo
    }()
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.alpha = 1
            
        }, completion: nil)
        
        showMenu(menu: eventInfoView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EventController.handleDismiss))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    func showMenu(menu: Menu) {
        menu.show()
    }
    
    func handleDismiss() {
        dismissMenu(menu: eventInfoView)
    }

    func dismissMenu(menu: Menu) {
        menu.dismiss()
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
            self.view.alpha = 0
        }) { (true) in
            self.dismiss(animated: false, completion: nil)
        }
    }
}

extension EventController: EventInfoDelegate {
    func eventSelected(event: Event) {
        print(event.title)
        handleDismiss()
    }
}