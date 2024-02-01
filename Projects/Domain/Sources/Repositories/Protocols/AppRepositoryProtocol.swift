//
//  AppRepositoryProtocol.swift
//  Domain
//
//  Created by 강현준 on 1/28/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol AppRepositoryProtocol {
    func wish(message: String) -> Single<String>
    
    func getNotificationSetting() -> Single<NotificationSettings>
    func setActivitySetting(isOn: Bool) -> Completable
}
