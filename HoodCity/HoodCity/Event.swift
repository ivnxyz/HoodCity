//
//  Event.swift
//  HoodCity
//
//  Created by Iván Martínez on 30/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation

struct Event {
    let location: CLLocation
    let id: String
    var eventData: EventData!
}

extension Event {
    init?(eventDict: [String: AnyObject], id: String) {

        guard let locationArray = eventDict["l"] as? [Double] else {
            print("Cannot get info from event dictionary")
            return nil
        }
        
        let latitude = locationArray[0]
        let longitude = locationArray[1]
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        self.init(location: location, id: id, eventData: nil)
    }
}

struct EventData {
    let date: Date
    let eventType: EventType
    let userID: String
}

extension EventData {
    init?(eventDict: [String: AnyObject]) {
        guard let dateStringValue = eventDict["date"] as? String, let type = eventDict["type"] as? String, let userID = eventDict["publishedBy"] as? String else {
            print("Cannot get info from event's data dictionary")
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
        
        self.init(date: date, eventType: eventType, userID: userID)
    }
}
