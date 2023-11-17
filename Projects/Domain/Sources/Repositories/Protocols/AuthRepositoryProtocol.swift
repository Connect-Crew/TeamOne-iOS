//
//  LoginRepositoryProtocol.swift
//  Domain
//
//  Created by 강현준 on 2023/11/07.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol AuthRepositoryProtocol {
    func login(request: OAuthLoginProps) -> Observable<Bool>

    func autoLogin() -> Observable<Bool> 

    func register(props: OAuthSignUpProps) -> Observable<Bool>
}
