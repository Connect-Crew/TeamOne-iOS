//
//  MyProjectType.swift
//  Core
//
//  Created by Junyoung on 1/28/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import UIKit

public enum MyProjectType: CaseIterable {
    case myProject
    case submittedProject
    case favoriteProject
    
    public var toName: String {
        switch self {
        case .myProject:
            return "나의 프로젝트"
        case .submittedProject:
            return "나의 지원 현황"
        case .favoriteProject:
            return "관심 프로젝트"
        }
    }
    
}
