//
//  EventDate.swift
//  HoodCity
//
//  Created by Iván Martínez on 04/09/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation

struct EventDate {
    
    static let localeIdentifier = "en_US_POSIX"
    static let dateFormat = "dd-MM-yyyy HH:mm"
    
    static func getCurrentDateString() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: localeIdentifier)
        formatter.dateFormat = dateFormat
        
        let dateStringRepresentation = formatter.string(from: currentDate)
        
        return dateStringRepresentation
    }
    
    static func getDateFrom(string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: localeIdentifier)
        formatter.dateFormat = dateFormat
        
        let date = formatter.date(from: string)
        
        return date
    }
}
