//
//  ProjectState.swift
//  Domain
//
//  Created by 강현준 on 12/3/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public enum ProjectState: CaseIterable {
    case before
    case running
    case completed
    case deleted
    
    public func toMultiPartValue() -> String {
        switch self {
        case .before: return "NOT_STARTED"
        case .running: return "IN_PROGRESS"
        case .completed: return "COMPLETED"
        case .deleted: return "DELETED"
        }
    }
    
    public func toString() -> String {
        switch self {
        case .before: return "진행 전"
        case .running: return "진행 중"
        case .completed: return "종료"
        case .deleted: return "삭제"
        }
    }
    
    public static func findState(string: String) -> ProjectState {
        guard let state = Self.allCases.first(where: { $0.toString() == string }) else {
            assert(true)
            return .before
        }
        return state
    }
}
