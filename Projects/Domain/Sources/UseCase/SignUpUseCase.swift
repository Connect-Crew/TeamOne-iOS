//
//  SignUpUseCase.swift
//  Domain
//
//  Created by 강현준 on 2023/11/15.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol SignUpUseCaseProtocol {
    func signUp(signUpProps: OAuthSignUpProps) -> Observable<Bool>
}

public struct SignUpUseCase: SignUpUseCaseProtocol {

    let authRepository: AuthRepositoryProtocol
    let tokenRepository: TokenRepositoryProtocol

    public init(authRepository: AuthRepositoryProtocol, tokenRepository: TokenRepositoryProtocol) {
        self.authRepository = authRepository
        self.tokenRepository = tokenRepository
    }

    public func signUp(signUpProps: OAuthSignUpProps) -> Observable<Bool> {
        return authRepository.register(props: signUpProps)
    }
}
