//
//  ProjectState.swift
//  Domain
//
//  Created by 강현준 on 12/3/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public enum ProjectState {
    case before
    case running
    
    public func toMultiPartValue() -> String {
        switch self {
        case .before:
            return "NOT_STARTED"
        case .running:
            return "IN_PROGRESS"
        }
    }
}
