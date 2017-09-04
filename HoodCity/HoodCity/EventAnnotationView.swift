//
//  EventAnnotationView.swift
//  HoodCity
//
//  Created by Iván Martínez on 21/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit

class EventAnnotationView: MKAnnotationView {

    init(eventAnnotation: EventAnnotation, reuseIdentifier: String?) {
        super.init(annotation: eventAnnotation, reuseIdentifier: reuseIdentifier)
        
        self.image = eventAnnotation.event.eventType.icon
        self.canShowCallout = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
