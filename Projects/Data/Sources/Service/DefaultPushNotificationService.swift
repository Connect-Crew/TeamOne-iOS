//
//  DefaultPushNotificationService.swift
//  Data
//
//  Created by 강현준 on 1/31/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import FirebaseMessaging
import RxSwift
import Domain

public struct DefaultPushNotificationService: PushNotificationService {
    
    public func deleteToken() -> Single<Void> {
        return Single.create { single in
            Messaging.messaging().deleteToken() { error in
                if let error = error {
                    single(.failure(error))
                }
                single(.success(()))
            }
            return Disposables.create()
        }
    }
    
    public init () {}
}
