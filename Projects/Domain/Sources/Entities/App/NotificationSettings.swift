//
//  NotificationSettings.swift
//  Domain
//
//  Created by 강현준 on 1/31/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public struct NotificationSettings {
    public var activitySetting: Bool
    
    public init(activitySetting: Bool) {
        self.activitySetting = activitySetting
    }
    
    public static var isNotSet: NotificationSettings {
        return NotificationSettings(activitySetting: false)
    }
}
