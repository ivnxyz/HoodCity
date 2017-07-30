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
    let type: EventType
    let location: CLLocation
}

extension Event {
    init?(eventDict: [String: AnyObject]) {

        guard let dateStringValue = eventDict["date"] as? String, let type = eventDict["type"] as? String, let locationArray = eventDict["l"] as? [Double] else {
            print("Cannot get info from event dictionary")
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/M/yyyy, H:mm"
        
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
        
        self.init(date: date, type: eventType, location: location)
    }
}
