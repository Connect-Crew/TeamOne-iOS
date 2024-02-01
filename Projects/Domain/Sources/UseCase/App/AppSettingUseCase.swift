//
//  AppSettingUseCase.swift
//  Domain
//
//  Created by 강현준 on 1/31/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol AppSettingUseCase {
    func getNotificationSetting() -> Single<NotificationSettings>
    func setActivitySetting(isOn: Bool) -> Completable
}

public struct DefaultAppSettingUseCase: AppSettingUseCase {
    
    let appRepository: AppRepositoryProtocol
    
    public init(appRepository: AppRepositoryProtocol) {
        self.appRepository = appRepository
    }
    
    public func getNotificationSetting() -> Single<NotificationSettings> {
        return appRepository.getNotificationSetting()
    }
    
    public func setActivitySetting(isOn: Bool) -> Completable {
        return appRepository.setActivitySetting(isOn: isOn)
    }
}
