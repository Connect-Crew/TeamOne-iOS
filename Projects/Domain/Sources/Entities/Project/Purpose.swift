//
//  Purpose.swift
//  Domain
//
//  Created by 강현준 on 12/8/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public enum Purpose {
    case none
    case startup
    case portfolio
    
    public func toMultiPartValue() -> String {
        switch self {
        case .none:
            fatalError()
        case .startup:
            return "STARTUP"
        case .portfolio:
            return "PORTFOLIO"
        }
    }
}
