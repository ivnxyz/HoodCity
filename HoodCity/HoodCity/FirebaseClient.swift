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
    let userReference = Database.database().reference().child("users/ivnxyz")
    
    func addEvent(withID id: String) {
        userReference.updateChildValues(["\(id)": true])
    }
    
    func addDateToEvent(eventID id: String) {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/M/yyyy, H:mm"
        
        let dateStringRepresentation = formatter.string(from: currentDate)
        
        reference.child(id).updateChildValues(["date": dateStringRepresentation])
    }
    
    func add(eventType: Event, toEvent id: String) {
        let eventType = eventType.title
        
        reference.child(id).updateChildValues(["type": eventType])
    }
    
    func dateOf(eventID id: String, completionHandler: @escaping (Date?, FirebaseError?) -> Void) {
        reference.child(id).child("date").observeSingleEvent(of: .value, with: { (snapshot) in
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
}
