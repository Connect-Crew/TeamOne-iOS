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
}
