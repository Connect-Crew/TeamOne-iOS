//
//  SettingType.swift
//  Core
//
//  Created by Junyoung on 1/28/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import UIKit

public enum SettingType: CaseIterable {
    case setting
    case supportCenter
    
    public var toName: String {
        switch self {
        case .setting:
            return "설정"
        case .supportCenter:
            return "고객센터"
        }
    }
    
    public enum NotificationSettingType {
        
        case activity(Bool)
        
        public var toName: String {
            switch self {
            case .activity: return "활동 알림 (지원 응답, 팀원 변동사항 등)"
            }
        }
    }
    
}
