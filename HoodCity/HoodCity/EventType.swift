//
//  EventType.swift
//  HoodCity
//
//  Created by Iván Martínez on 13/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation

enum EventType {
    case traffic
    case protest
    case party
    case sportEvent
    case meetup
    case art
    case rain
    
    static var count: Int { return EventType.rain.hashValue + 1}
}

extension EventType {
    init?(type: String) {
        switch type {
        case "traffic":
            self = .traffic
        case "protest":
            self = .protest
        case "party":
            self = .party
        case "sportEvent":
            self = .sportEvent
        case "meetup":
            self = .meetup
        case "artEvent":
            self = .art
        case "rain":
            self = .rain
        default:
            return nil
        }
    }
}

extension EventType {
    init?(index: Int) {
        switch index {
        case 0:
            self = .traffic
        case 1:
            self = .protest
        case 2:
            self = .party
        case 3:
            self = .sportEvent
        case 4:
            self = .meetup
        case 5:
            self = .art
        case 6:
            self = .rain
        default:
            return nil
        }
    }
}

extension EventType {
    var title: String {
        switch self {
        case .traffic:
            return NSLocalizedString("EventType.Traffic", comment: "") 
        case .protest:
            return NSLocalizedString("EventType.Protest", comment: "")
        case .party:
            return NSLocalizedString("EventType.Party", comment: "")
        case .sportEvent:
            return NSLocalizedString("EventType.SportEvent", comment: "")
        case .meetup:
            return NSLocalizedString("EventType.Meetup", comment: "")
        case .art:
            return NSLocalizedString("EventType.ArtEvent", comment: "")
        case .rain:
            return NSLocalizedString("EventType.Rain", comment: "")
        }
    }
    
    var type: String {
        switch self {
        case .traffic:
            return "traffic"
        case .protest:
            return "protest"
        case .party:
            return "party"
        case .sportEvent:
            return "sportEvent"
        case .meetup:
            return "meetup"
        case .art:
            return "artEvent"
        case .rain:
            return "rain"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .traffic:
            return #imageLiteral(resourceName: "traffic")
        case .protest:
            return #imageLiteral(resourceName: "protest")
        case .party:
            return #imageLiteral(resourceName: "party")
        case .sportEvent:
            return #imageLiteral(resourceName: "sportEvent")
        case .meetup:
            return #imageLiteral(resourceName: "meetup")
        case .art:
            return #imageLiteral(resourceName: "artEvent")
        case .rain:
            return #imageLiteral(resourceName: "rain")
        }
    }
    
    var cleanTitle: String {
        switch self {
        case .traffic:
            return NSLocalizedString("EventType.Traffic.CleanTitle", comment: "")
        case .protest:
            return NSLocalizedString("EventType.Protest.CleanTitle", comment: "")
        case .party:
            return NSLocalizedString("EventType.Party.CleanTitle", comment: "")
        case .sportEvent:
            return NSLocalizedString("EventType.SportEvent.CleanTitle", comment: "")
        case .meetup:
            return NSLocalizedString("EventType.Meetup.CleanTitle", comment: "")
        case .art:
            return NSLocalizedString("EventType.ArtEvent.CleanTitle", comment: "")
        case .rain:
            return NSLocalizedString("EventType.Rain.CleanTitle", comment: "")
        }
    }
}


















