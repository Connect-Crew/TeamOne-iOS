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
import Core
import TeamOneNetwork

import FirebaseMessaging

enum AuthError: Error {
    case apnsError
}

public struct AuthRepository: AuthRepositoryProtocol {

    let authDataSource: AuthDataSourceProtocol

    public init(authDataSource: AuthDataSourceProtocol) {
        self.authDataSource = authDataSource
    }

    public func login(request: OAuthLoginProps) -> Observable<Bool> {

        guard let token = UserDefaultKeyList.Auth.APNsToken else { return Observable.error(AuthError.apnsError) }

        let requestDTO = AuthLoginRequestDTO(
            token: request.token,
            social: request.social.toString,
            fcm: token
        )

        return authDataSource.login(requestDTO)
            .map { result in
                UserDefaultKeyList.Auth.appAccessToken = result.token
                UserDefaultKeyList.Auth.appLoginSocial = requestDTO.social
                UserDefaultKeyList.Auth.appRefreshToken = result.refreshToken

                return true
            }
            .catch({ error in

                guard
                    let error = error as? APIError,
                    case .network(let statusCode) = error,
                    statusCode == 400
                else {
                    return self.authDataSource.reissuance()
                        .do(onNext: { newAccessToken in
                            UserDefaultKeyList.Auth.appAccessToken = newAccessToken.token
                        })
                        .map { _ in true }
                        .catch({ _ in return Observable.just(false) })
                }

                return Observable.just(false)
            })
    }

    public func autoLogin() -> Observable<Bool> {
        return authDataSource.reissuance()
            .do(onNext: { newAccessToken in
                UserDefaultKeyList.Auth.appAccessToken = newAccessToken.token
            })
            .map { _ in true }
    }

    public func register(props: OAuthSignUpProps) -> Observable<Bool> {

        guard let token = UserDefaultKeyList.Auth.APNsToken else { return Observable.error(AuthError.apnsError) }

        let requestDTO = AuthRegisterRequestDTO(
            token: props.token,
            social: props.social.toString,
            username: props.username,
            nickname: props.nickName,
            email: props.email,
            termsAgreement: true,
            privacyAgreement: true,
            fcm: token
        )

        return authDataSource.signup(requestDTO)
            .map { entity in

                UserDefaultKeyList.Auth.appAccessToken = entity.token
                UserDefaultKeyList.Auth.appRefreshToken = entity.refreshToken
                UserDefaultKeyList.Auth.appLoginSocial = requestDTO.social

                return true
            }
    }
}
