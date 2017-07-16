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
    
    static var count: Int { return Event.party.hashValue + 1}
}

extension Event {
    init?(type: String) {
        switch type {
        case "Traffic":
            self = .traffic
        case "Protest":
            self = .protest
        case "Party":
            self = .party
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
        default:
            return nil
        }
    }
}

extension Event {
    var title: String {
        switch self {
        case .traffic:
            return "Traffic"
        case .protest:
            return "Protest"
        case .party:
            return "Party"
        }
    }
}
