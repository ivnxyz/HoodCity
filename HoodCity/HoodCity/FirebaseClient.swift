//
//  FirebaseClient.swift
//  HoodCity
//
//  Created by Iván Martínez on 12/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseClient {
    
    let reference = Database.database().reference()
    let eventsReference = Database.database().reference().child("events")
    
    func addDateToExistingEvent(_ eventId: String) {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/M/yyyy, H:mm"
        
        let dateStringRepresentation = formatter.string(from: currentDate)
        
        eventsReference.child(eventId).updateChildValues(["date": dateStringRepresentation])
    }
    
    func addEventType(_ eventType: Event, to eventId: String) {
        let eventType = eventType.type
        
        eventsReference.child(eventId).updateChildValues(["type": eventType])
    }
    
    // Get information from event id
    
    func getDate(from eventId: String, completionHandler: @escaping (Date?, FirebaseError?) -> Void) {
        eventsReference.child(eventId).child("date").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dateStringValue = snapshot.value as? String else {
                completionHandler(nil, FirebaseError.snapshotValueIsEmpty)
                return
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/M/yyyy, H:mm"
            
            guard let date = formatter.date(from: dateStringValue) else {
                completionHandler(nil, FirebaseError.failedToTransformStringToData)
                return
            }
            
            completionHandler(date, nil)
        })
    }
    
    func getType(from eventId: String, completionHandler: @escaping (Event) -> Void) {
        eventsReference.child(eventId).child("type").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let eventType = snapshot.value as? String else { return }
            
            guard let event = Event(type: eventType) else { return }
            
            completionHandler(event)
        })
    }
}
