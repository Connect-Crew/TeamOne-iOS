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

    public func login(request: OAuthLoginProps) -> Single<Bool> {

        guard let token = UserDefaultKeyList.Auth.APNsToken else {
            return Single.error(AuthError.apnsError)
        }

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
    }

    public func reissuance() -> Single<RefreshToken> {
        return authDataSource.reissuance()
            .map { $0.toDomain() }
    }

    public func autoLogin() -> Single<Void> {
        
        return Single.create { single in
            guard let _ = UserDefaultKeyList.Auth.appAccessToken,
                  let _ = UserDefaultKeyList.Auth.appRefreshToken else {
                
                single(.failure(APIError.notToken))
                return Disposables.create()
            }
            
            single(.success(()))
            return Disposables.create()
        }
    }

    public func register(props: OAuthSignUpProps) -> Single<Bool> {

        guard let token = UserDefaultKeyList.Auth.APNsToken else { return Single.error(AuthError.apnsError) }

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
