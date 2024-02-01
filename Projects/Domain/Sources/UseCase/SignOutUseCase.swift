//
//  SignOutUseCase.swift
//  Domain
//
//  Created by 강현준 on 1/31/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol SignOutUseCase {
    func signOut() -> Single<Void>
}

public struct SignOut: SignOutUseCase {
    
    let userRepository: UserRepositoryProtocol
    let pushNotificationService: PushNotificationService
    
    public init(userRepository: UserRepositoryProtocol, pushNotificationService: PushNotificationService) {
        self.userRepository = userRepository
        self.pushNotificationService = pushNotificationService
    }
    
    public func signOut() -> Single<Void> {
        return pushNotificationService.deleteToken()
            .flatMap { userRepository.deleteUserData() }
    }
}
