//
//  Event.swift
//  HoodCity
//
//  Created by Iván Martínez on 30/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation

struct Event {
    let date: Date
    let eventType: EventType
    let location: CLLocation
    let userId: String
    let id: String
}

extension Event {
    init?(eventDict: [String: AnyObject], id: String) {

        guard let dateStringValue = eventDict["date"] as? String, let type = eventDict["type"] as? String, let locationArray = eventDict["l"] as? [Double], let userId = eventDict["publishedBy"] as? String else {
            print("Cannot get info from event dictionary")
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        guard let date = formatter.date(from: dateStringValue) else {
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
        
        self.init(date: date, eventType: eventType, location: location, userId: userId, id: id)
    }
}
