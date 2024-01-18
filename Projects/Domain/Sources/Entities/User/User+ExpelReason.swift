//
//  User+ExpelReason.swift
//  Domain
//
//  Created by 강현준 on 1/12/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public enum User_ExpelReason {
    
    case foulLanguage
    case lowParticipation
    case conflicWithTeamMembers
    case voluntaryWithdrawal
    case inappropriateContent
    case other(String)
    
    public var description: String {
        switch self {
        case .foulLanguage:
            return "욕설 / 비하발언"
        case .lowParticipation:
            return "참여율 저조\n(응답률, 접속률, 투표 진행 등)"
        case .conflicWithTeamMembers:
            return "팀원과의 불화"
        case .voluntaryWithdrawal:
            return "자진 중도 포기"
        case .inappropriateContent:
            return "19+ 음란성, 만남유도"
        case .other:
            return "기타"
        }
    }
    
    static func descriptionToCase(input: String) -> User_ExpelReason {
        let first = User_ExpelReason.allCases.first(where: { $0.description == input })
        
        if let first = first {
            return first
        } else {
            fatalError("\(input)is Unknown Case")
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
        .conflicWithTeamMembers,
        .foulLanguage,
        .inappropriateContent,
        .lowParticipation,
        .voluntaryWithdrawal,
        .other("")
    ]
}