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
