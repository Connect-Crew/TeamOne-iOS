//
//  AutoLoginUseCase.swift
//  Domain
//
//  Created by 강현준 on 2023/11/16.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift
import Core

public protocol AutoLoginUseCaseProtocol {
    func autoLogin() -> Observable<Bool>
}

public struct AutoLoginUseCase: AutoLoginUseCaseProtocol {

    let authRepository: AuthRepositoryProtocol

    public init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }

    public func autoLogin() -> Observable<Bool> {
        return authRepository.autoLogin()
    }
}
