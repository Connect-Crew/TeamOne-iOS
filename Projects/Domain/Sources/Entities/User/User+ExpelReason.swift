//
//  User+ExpelReason.swift
//  Domain
//
//  Created by 강현준 on 1/12/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public enum User_ExpelReason {
    
    case abuse
    case bad_Participation
    case dissension
    case givenUp
    case obscenity
    case etc(String)
    
    public var description: String {
        switch self {
        case .abuse:
            return "욕설 / 비하발언"
        case .bad_Participation:
            return "참여율 저조\n(응답률, 접속률, 투표 진행 등)"
        case .dissension:
            return "팀원과의 불화"
        case .givenUp:
            return "자진 중도 포기"
        case .obscenity:
            return "19+ 음란성, 만남유도"
        case .etc:
            return "기타"
        }
    }
    
    public var toRequestTypeString: String {
        switch self {
        case .abuse: return "ABUSE"
        case .bad_Participation: return "BAD_PARTICIPATION"
        case .dissension: return "DISSENSION"
        case .givenUp: return "GIVEN_UP"
        case .obscenity: return "OBSCENITY"
        case .etc: return "ETC"
        }
    }
    
    public var toRequestReasonString: String {
        switch self {
        case .abuse:
            return "욕설/비하발언"
        case .bad_Participation:
            return "참여율저조"
        case .dissension:
            return "팀원과의 불화"
        case .givenUp:
            return "자진 중도 포기"
        case .obscenity:
            return "19+ 음란성, 만남유도"
        case .etc(let reason):
            return reason
        }
    }
}

extension User_ExpelReason: Equatable {
    
    public static func == (lhs: User_ExpelReason, rhs: User_ExpelReason) -> Bool {
            return lhs.description == rhs.description
        
    }
}

extension User_ExpelReason: CaseIterable {
    
    public static var allCases: [User_ExpelReason] = [
        .dissension,
        .abuse,
        .obscenity,
        .bad_Participation,
        .givenUp,
        .etc("")
    ]
}
