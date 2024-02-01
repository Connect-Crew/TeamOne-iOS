//
//  AppRepository.swift
//  Data
//
//  Created by 강현준 on 1/28/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import RxSwift
import Domain
import Core

public struct AppRepository: AppRepositoryProtocol {

    private let appDataSource: AppDataSourceProtocol

    public init(appDataSource: AppDataSourceProtocol) {
        self.appDataSource = appDataSource
    }

    public func wish(message: String) -> Single<String> {
        let request = WishRequestDTO(message: message)
        return appDataSource.wish(request: request)
            .map { $0.message }
    }
    
    public func getNotificationSetting() -> Single<NotificationSettings> {
        return Single.create { single in
            
            let activitySetting = UserDefaultKeyList.Setting.Notification.activity ?? false

            let settings = NotificationSettings(activitySetting: activitySetting)
            
            single(.success(settings))
            
            return Disposables.create()
        }
    }
    
    public func setActivitySetting(isOn: Bool) -> Completable {
        
        return Completable.create { complete in
            
            UserDefaultKeyList.Setting.Notification.activity = isOn
            
            complete(.completed)
            
            return Disposables.create()
        }
    }
}
