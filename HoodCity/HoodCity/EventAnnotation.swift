//
//  EventAnnotation.swift
//  HoodCity
//
//  Created by Iván Martínez on 12/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation

class EventAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var event: Event
    
    init(coordinate: CLLocationCoordinate2D, eventType: Event) {
        self.coordinate = coordinate
        self.title = eventType.title
        self.event = eventType
    }
}
