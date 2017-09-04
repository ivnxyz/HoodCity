//
//  EventData.swift
//  HoodCity
//
//  Created by Iván Martínez on 04/09/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation

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
