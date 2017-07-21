//
//  EventInfoView.swift
//  HoodCity
//
//  Created by Iván Martínez on 16/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation
import UIKit

protocol EventInfoDelegate: class {
    func eventSelected(event: Event)
}

class EventInfoView: UIView, Menu {
    
    lazy var backgroundView: UIView = {
        guard let window = UIApplication.shared.keyWindow else { return UIView() }
        
        let backgroundViewHeight = window.frame.height - 200
        let backgroundViewWidth = window.frame.width
        
        let view = UIView(frame: CGRect(x: 0, y: backgroundViewHeight * 2, width: backgroundViewWidth, height: backgroundViewHeight))
        
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var eventPicker: UIPickerView = {
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        return pickerView
    }()
    
    lazy var addEventButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add event", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(EventInfoView.addEvent), for: .touchUpInside)
        
        return button
    }()
    
    lazy var addEventLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Add a new event"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var eventInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "This event will disappear in 12 hours."
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var adView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    weak var delegate: EventInfoDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func show() {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        window.addSubview(backgroundView)
        backgroundView.addSubview(addEventLabel)
        backgroundView.addSubview(eventPicker)
        backgroundView.addSubview(addEventButton)
        backgroundView.addSubview(eventInfoLabel)
        backgroundView.addSubview(adView)
        
        NSLayoutConstraint.activate([
            addEventLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            addEventLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addEventButton.topAnchor.constraint(equalTo: eventPicker.bottomAnchor, constant: 30),
            addEventButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            addEventButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            addEventButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            eventPicker.topAnchor.constraint(equalTo: addEventLabel.bottomAnchor, constant: 32),
            eventPicker.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            eventPicker.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            eventPicker.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            eventInfoLabel.topAnchor.constraint(equalTo: addEventButton.bottomAnchor, constant: 7),
            eventInfoLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            adView.heightAnchor.constraint(equalToConstant: 50),
            adView.widthAnchor.constraint(equalToConstant: 320),
            adView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            adView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
        
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            let backgroundViewY = window.frame.height - self.backgroundView.frame.height
            
            self.backgroundView.frame = CGRect(x: 0, y: backgroundViewY, width: self.backgroundView.frame.width, height: self.backgroundView.frame.height)
            
        }, completion: nil)
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.4) {
            self.backgroundView.alpha = 0
            
            self.backgroundView.frame = CGRect(x: 0, y: self.backgroundView.frame.height * 2, width: self.backgroundView.frame.width, height: self.backgroundView.frame.height)
        }
        
        self.removeFromSuperview()
    }
    
    func addEvent() {
        let selectedEventIndex = eventPicker.selectedRow(inComponent: 0)
        guard let event = Event(index: selectedEventIndex) else { return }
        
        delegate?.eventSelected(event: event)
    }
}

extension EventInfoView: UIPickerViewDelegate {
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let event = Event(index: row)
        return event!.title
    }

}

extension EventInfoView: UIPickerViewDataSource {
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Event.count
    }
    
}


