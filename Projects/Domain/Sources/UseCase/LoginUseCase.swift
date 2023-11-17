//
//  LoginUseCase.swift
//  DomainTests
//
//  Created by 강현준 on 2023/11/07.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift
import Core

public protocol LoginUseCaseProtocol {
    func login(props: OAuthLoginProps) -> Observable<Bool>
}

public struct LoginUseCase: LoginUseCaseProtocol {

    let authRepository: AuthRepositoryProtocol
    let tokenRepository: TokenRepositoryProtocol

    public init(authRepository: AuthRepositoryProtocol, tokenRepository: TokenRepositoryProtocol) {
        self.authRepository = authRepository
        self.tokenRepository = tokenRepository
    }

    public func login(props: OAuthLoginProps) -> Observable<Bool> {
        return authRepository.login(request: props)
    }
}
