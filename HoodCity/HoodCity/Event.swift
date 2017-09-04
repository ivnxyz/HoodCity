//
//  Event.swift
//  HoodCity
//
//  Created by Iván Martínez on 30/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation

class Event {
    let location: CLLocation
    let id: String
    let date: Date
    let eventType: EventType
    var eventData: EventData!
    
    init(location: CLLocation, id: String, date: Date, eventType: EventType, eventData: EventData?) {
        self.location = location
        self.id = id
        self.date = date
        self.eventType = eventType
        self.eventData = eventData
    }
}

extension Event {
    convenience init?(eventDict: [String: AnyObject], id: String) {

        guard let locationArray = eventDict["l"] as? [Double], let dateStringValue = eventDict["date"] as? String, let type = eventDict["type"] as? String else {
            print("Cannot get info from event dictionary")
            return nil
        }
        
        guard let date = EventDate.getDateFrom(string: dateStringValue) else {
            print("Not a valid date")
            
            return nil
        }
        
        guard let eventType = EventType(type: type) else {
            print("Not a valid event type")
            return nil
        }
        
        let latitude = locationArray[0]
        let longitude = locationArray[1]
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        self.init(location: location, id: id, date: date, eventType: eventType, eventData: nil)
    }
}
