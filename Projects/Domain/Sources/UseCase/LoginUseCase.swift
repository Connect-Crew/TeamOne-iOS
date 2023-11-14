//
//  LoginUseCase.swift
//  DomainTests
//
//  Created by 강현준 on 2023/11/07.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

enum LoginCase {
    case kakao
}

enum LoginResult {
    case success
    case failure
}

protocol LoginUseCaseProtocol {
    func login(loginCase: LoginCase)
}

struct LoginUseCase: LoginUseCaseProtocol {
    
    var repository: LoginRepositoryProtocol
    
    func login(loginCase: LoginCase){}
}
