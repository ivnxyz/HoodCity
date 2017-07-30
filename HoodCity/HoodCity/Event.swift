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
}

extension Event {
    init?(eventDict: [String: AnyObject]) {
        guard let date = eventDict["date"] as? Date, let type = eventDict["type"] as? String else { return nil }
        
        let eventType = EventType(type: type)
        
        self.init(date: date, type: eventType)
    }
}
