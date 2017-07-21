//
//  Event.swift
//  HoodCity
//
//  Created by Iván Martínez on 13/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation

enum Event {
    case traffic
    case protest
    case party
    case sportEvent
    case meetup
    case art
    case rain
    case pride
    
    static var count: Int { return Event.pride.hashValue + 1}
}

extension Event {
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
        case "pride":
            self = .pride
        default:
            return nil
        }
    }
}

extension Event {
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
        case 7:
            self = .pride
        default:
            return nil
        }
    }
}

extension Event {
    var title: String {
        switch self {
        case .traffic:
            return "🚦 Traffic"
        case .protest:
            return "✋ Protest"
        case .party:
            return "🎉 Party"
        case .sportEvent:
            return "🏆 Sport event"
        case .meetup:
            return "🍻 Meetup"
        case .art:
            return "🎭 Art event"
        case .rain:
            return "🌧 Rain"
        case .pride:
            return "🏳️‍🌈 Pride"
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
        case .pride:
            return "pride"
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
        case .pride:
            return #imageLiteral(resourceName: "pride")
        }
    }
}


















