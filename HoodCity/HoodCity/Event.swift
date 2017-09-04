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
    let date: Date
    let eventType: EventType
    var eventData: EventData!
}

extension Event {
    init?(eventDict: [String: AnyObject], id: String) {

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

struct EventData {
    let userID: String
}

extension EventData {
    init?(eventDict: [String: AnyObject]) {
        guard let userID = eventDict["publishedBy"] as? String else {
            print("Cannot get info from event's data dictionary")
            return nil
        }
        
        self.init(userID: userID)
    }
}
