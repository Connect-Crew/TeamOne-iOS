//
//  User+Exple.swift
//  Domain
//
//  Created by 강현준 on 1/12/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public enum User_ExpleReason {
    
    case foulLanguage
    case lowParticipation
    case conflicWithTeamMembers
    case voluntaryWithdrawal
    case inappropriateContent
    case other(String)
    
    var description: String {
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
}

extension User_ExpleReason: CaseIterable {
    public static var allCases: [User_ExpleReason] {
        return [
            .foulLanguage,
            .lowParticipation,
            .conflicWithTeamMembers,
            .voluntaryWithdrawal,
            .inappropriateContent,
            .other("")
        ]
    }
}
