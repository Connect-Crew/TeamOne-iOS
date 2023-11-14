//
//  LoginReporitory.swift
//  Data
//
//  Created by 강현준 on 2023/11/07.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser

import Foundation
import RxSwift
import Domain

public struct LoginRepository: LoginRepositoryProtocol {

    public var loginDataSource: LoginDataSourceProtocol

    public init (loginDataSource: LoginDataSourceProtocol) {
        self.loginDataSource = loginDataSource
    }
    
    public func getkakaoOAuthToken() -> Single<Authorization> {
        return loginDataSource.getKakaoToken()
            .map {
                return Authorization(
                    accessToken: $0.accessToken,
                    refreshToken: $0.refreshToken,
                    idToken: $0.idToken
                )
            }
    }
}
