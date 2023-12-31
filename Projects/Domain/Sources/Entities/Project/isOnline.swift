//
//  Region.swift
//  Domain
//
//  Created by 강현준 on 12/3/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public enum isOnline {
    case online
    case onOffline
    case offline
    case none
    
    func toString() -> String {
        switch self {
        case .online:
            return "online"
        case .onOffline:
            return "onOffline"
        case .offline:
            return "offline"
        case .none:
            return "nil"
        }
    }
    
    public func toBool() -> Bool {
        switch self {
        case .online:
            return true
        case .onOffline:
            return false
        case .offline:
            return false
        case .none:
            return false
        }
    }
}
