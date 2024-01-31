//
//  PushNotificationService.swift
//  Domain
//
//  Created by 강현준 on 1/31/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol PushNotificationService {
    func deleteToken() -> Single<Void>
}
