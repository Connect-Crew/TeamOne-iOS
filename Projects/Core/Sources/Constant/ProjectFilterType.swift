//
//  ProjectFilterType.swift
//  Core
//
//  Created by Junyoung on 12/12/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public enum ProjectFilterType: CaseIterable {
    case reset
    case goal
    case career
    case region
    case online
    case part
    case skills
    case states
    
    public var toString: String {
        switch self {
        case .goal:
            return "목적"
        case .career:
            return "경력"
        case .region:
            return "지역"
        case .online:
            return "뭔데이건"
        case .part:
            return "직무"
        case .skills:
            return "기술"
        case .states:
            return "한잔해"
        case .reset:
            return "초기화"
        }
    }
}
