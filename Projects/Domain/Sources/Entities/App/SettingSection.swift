//
//  SettingSection.swift
//  Domain
//
//  Created by 강현준 on 2/1/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public enum SettingSection: Int, CaseIterable, Hashable {
    case notification
    case policy
    case app
    
    public var title: String? {
        switch self {
        case .notification: return "알림 설정"
        case .policy: return "정책 관련"
        case .app: return nil
        }
    }
}

public enum SettingCellType: Hashable {
    case activityNotification(Bool)
    case termsOfService
    case privacyPolicy
    case logout
    case dropout
    
    public var title: String {
        switch self {
        case .activityNotification:
            return "활동 알림(지원 응답, 팀원 변동사항 등)"
        case .termsOfService:
            return "서비스 이용약관"
        case .privacyPolicy:
            return "개인정보 처리방침"
        case .logout:
            return "로그아웃"
        case .dropout:
            return "탈퇴하기"
        }
    }
}
