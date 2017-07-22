//
//  EventAnnotationView.swift
//  HoodCity
//
//  Created by Iván Martínez on 21/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit

class EventAnnotationView: MKAnnotationView {

    init(eventAnnotation: EventAnnotation, reuseIdentifier: String?) {
        super.init(annotation: eventAnnotation, reuseIdentifier: reuseIdentifier)
        
        let pinImage = eventAnnotation.event.icon
        let size = CGSize(width: 50, height: 50)
        
        UIGraphicsBeginImageContext(size)
        pinImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.image = resizedImage
        self.canShowCallout = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
